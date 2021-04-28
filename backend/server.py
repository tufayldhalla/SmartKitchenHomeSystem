from flask import Flask, request, jsonify
import requests
from datetime import datetime
import sys, os
sys.path.append(os.getcwd() + "/backend/database/")
from DBLibrary import DBLibrary

db_lib = DBLibrary()  # db library instance to use functions within library

app = Flask(__name__)  # create application instance

server_url = 'https://smart-kitchen-module.herokuapp.com/'

def nutrition_track(offset, userID, barcode):
    # Once items weight has been updated in users inventory, we want to update the users history table
    date = datetime.today().strftime('%Y-%m-%d') # get current date in YYYY-MM-DD format
    response = requests.get(server_url + 'get_from_users_history/' + date + '/' + userID + '/*')
    requested_data = response.json()
    nutrition = requests.get(server_url + 'get_product/' + str(barcode) + '/*') # get nutritional information for the desired item given barcode
    nutrition = nutrition.json()
    if requested_data: # If not None, then increment existing users history in table
        db_lib.update_macros_in_user_history(date, userID, barcode, offset)
    else:  # If None, then add users history in table
        data = {"ID": 0,
        "Date": date,
        "User_UID": userID,
        "Net_Calories": offset * nutrition["Calories"],                      
        "Net_Fat": offset * nutrition["Fat"],
        "Net_Saturated": offset * nutrition["Saturated"],
        "Net_Polyunsaturated": offset * nutrition["Polyunsaturated"],
        "Net_Monounsaturated": offset * nutrition["Monounsaturated"],
        "Net_Trans": offset * nutrition["Trans"],
        "Net_Cholesterol": offset * nutrition["Cholesterol"],
        "Net_Sodium": offset * nutrition["Sodium"],
        "Net_Carbohydrate": offset * nutrition["Carbohydrate"],          
        "Net_Fiber": offset * nutrition["Fiber"],
        "Net_Protein": offset * nutrition["Protein"],
        "Net_Sugars": offset * nutrition["Sugars"],
        "Net_Potassium": offset * nutrition["Potassium"],
        "Net_Vitamin_A": offset * nutrition["Vitamin_A"],
        "Net_Vitamin_C": offset * nutrition["Vitamin_C"],
        "Net_Calcium": offset * nutrition["Calcium"],
        "Net_Iron": offset * nutrition["Iron"]}
        requests.post(server_url + 'add_to_users_history', data)

# --------- Routes for App <-> Server <-> Products Table Communication --------- #

# Route to add an entry into the products table
@app.route('/add_product', methods=['POST'])
def add_product():
    json = request.json
    entry = (json["Barcode"],
             json["Name"],
             json["Weight"],
             json["Weight_Type"],
             json["Calories"],
             json["Fat"],
             json["Saturated"],
             json["Polyunsaturated"],
             json["Monounsaturated"],
             json["Trans"],
             json["Cholesterol"],
             json["Sodium"],
             json["Carbohydrate"],
             json["Fiber"],
             json["Protein"],
             json["Sugars"],
             json["Potassium"],
             json["Vitamin_A"],
             json["Vitamin_C"],
             json["Calcium"],
             json["Iron"])
    try:
        db_lib.insert_row("products", entry)
        print(f"Item added:\n{json}")
        return "Added Successfully"
    except AssertionError as e:
        raise AssertionError(
            "Could not add to the database table due to {}".format(e))

# Route to return a record from the products database based on a barcode
@app.route('/get_product/<int:barcode>/<columns>', methods=["GET"])
def get_product(barcode, columns):
    try:
        return jsonify(db_lib.filtered_query_row("products", barcode, columns=columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return a record from the products database based on a condition
@app.route('/get_product_based_on_condition/<condition>/<columns>', methods=["GET"])
def get_product_based_on_condition(condition, columns):
    try:
        return jsonify(db_lib.filtered_query_based_on_condition("products", condition, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))
    
# Route to return all records from the products database
@app.route('/get_all_products/<columns>', methods=["GET"])
def get_all_products(columns):
    try:
        return jsonify(db_lib.filtered_query_all_rows("products", columns=columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))
    
# Route to delete a record from the products database based on a barcode
@app.route('/delete_product/<int:barcode>', methods=["DELETE"])
def delete_product(barcode):
    try:
        db_lib.delete_row("products", barcode)
        return "Deleted Successfully"
    except AssertionError as e:
        raise AssertionError("Deleting an item failed due to {}".format(e))

# --------- Routes for Module <-> Server <-> Users Inventory Table Communication --------- #

# Route to add an entry into the users inventory table
@app.route('/add_to_user_inventory', methods=['POST'])
def add_to_user_inventory():
    json = request.json
    entry = (json["ID"],
             json["Barcode"],
             json["User_UID"],
             json["Name"],
             json["Measured_Weight"],
             json["Weight"],
             json["Weight_Type"],
             json["Expiration_Date"],
             json["Scanned"],
             json["Count"])
    try:
        db_lib.insert_row("users_inventory", entry)

        # Once user has added an item to users inventory, we want to update the item occurrence table
        response = requests.get(server_url + 'get_from_items_occurrences/' + str(entry[1]) + '/' + str(entry[2]) + '/*')
        requested_item = response.json()
        if requested_item: # If not None, then increment exisiting item occurrence in table
            data = {'param': "Occurrences", 'offset': 1}
            requests.put(server_url + 'update_w_offset_items_occurrences/' + str(entry[1]) + '/' + str(entry[2]), data)
        else:  # If None, then add item occurrence in table
            data = {'ID': 0, 'Barcode': entry[1], 'User_UID': entry[2], 'Name': entry[3], 'Occurrences': 1}
            requests.post(server_url + 'add_to_items_occurrences', data)

        return "Added Successfully"
    except AssertionError as e:
        raise AssertionError(
            "Could not add to the database table due to {}".format(e))

# Route to return a record from the users inventory table based on a barcode and user ID
@app.route('/get_from_user_inventory/<int:barcode>/<userID>/<columns>', methods=["GET"])
def get_from_user_inventory(barcode, userID, columns):
    try:
        return jsonify(db_lib.filtered_query_row("users_inventory", barcode, userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return a record from the users inventory table based on a condition
@app.route('/get_from_user_inventory_based_on_condition/<condition>/<columns>', methods=["GET"])
def get_from_user_inventory_based_on_condition(condition, columns):
    try:
        return jsonify(db_lib.filtered_query_based_on_condition("users_inventory", condition, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return all records for a user via user ID from the users inventory table
@app.route('/get_all_user_inventory/<userID>/<columns>', methods=["GET"])
def get_all_user_inventory(userID, columns):
    try:
        return jsonify(db_lib.filtered_query_all_rows("users_inventory", userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Delete a return a record from the users inventory table based on a barcode and user ID
@app.route('/delete_from_user_inventory/<int:barcode>/<userID>', methods=["DELETE"])
def delete_from_user_inventory(barcode, userID):
    try:
        # Get item information in users inventory
        response = requests.get(server_url + 'get_from_user_inventory/' + str(barcode) + '/' + userID + '/*')
        requested_data = response.json()
        # Once items weight has been updated in users inventory, we want to update the users history table
        count = int(requested_data["Count"])
        weight = float(requested_data["Weight"])
        if count == 1:
            nutrition_track(weight, userID, barcode)
        if count > 1:
            # Get initial weight from products table for this item
            response = requests.get(server_url + 'get_product/' + str(barcode) + '/*')
            product_data = response.json()
            offset = weight - product_data["Weight"] * (count-1)
            db_lib.update_row_with_offset("users_inventory", "Weight", -1*offset, barcode, userID)
            nutrition_track(offset, userID, barcode)

        db_lib.delete_row("users_inventory", barcode, userID)

        return "Deleted Successfully"
    except AssertionError as e:
        raise AssertionError("Deleting an item failed due to {}".format(e))

# Update a record from the users inventory table based on a barcode and user ID
@app.route('/update_w_offset_user_inventory/<int:barcode>/<userID>', methods=["PUT"])
def update_w_offset_user_inventory(barcode, userID):
    param = request.form['param']
    offset = request.form['offset']
    try:
        db_lib.update_row_with_offset("users_inventory", param, offset, barcode, userID)

        offset = float(offset) # make number
        print(param, type(param))
        if offset < 0 and param == "Weight": # If food has been consumed, if offset > 0 then that means more has been added to item
            # Once items weight has been updated in users inventory, we want to update the users history table
            nutrition_track(offset*-1, userID, barcode)

        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# Update a record from the users inventory table based on a barcode and user ID
@app.route('/update_user_inventory/<int:barcode>/<userID>', methods=["PUT"])
def update_user_inventory(barcode, userID):
    param = request.form['param']
    new_val = request.form['new_val']
    try:
        db_lib.update_row("users_inventory", param, new_val, userID, barcode)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# --------- Routes for Module <-> Server <-> Users Table Communication --------- #

# Route to add an entry into the users table
@app.route('/add_to_users', methods=['POST'])
def add_to_users():
    json = request.json
    entry = (json["User_UID"],
             json["Email"],
             json["First_Name"],
             json["Last_Name"],
             json["Gender"],
             json["Date_of_Birth"],
             json["Calorie_Goal"],
             json["Protein_Goal"],
             json["Carbohydrate_Goal"],
             json["Fat_Goal"],
             json["QR_Code"],
             json["Profile_Picture"])
    try:
        db_lib.insert_row("users", entry)
        return "Added Successfully"
    except AssertionError as e:
        raise AssertionError(
            "Could not add to the database table due to {}".format(e))

# Route to return a record from the users table based on user ID
@app.route('/get_from_users/<userID>/<columns>', methods=["GET"])
def get_from_users(userID, columns):
    try:
        return jsonify(db_lib.filtered_query_row("users", user_uid=userID, columns=columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return a record from the users table based on a condition
@app.route('/get_from_users_based_on_condition/<condition>/<columns>', methods=["GET"])
def get_from_users_based_on_condition(condition, columns):
    try:
        return jsonify(db_lib.filtered_query_based_on_condition("users", condition, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return all records from the users table
@app.route('/get_all_users/<columns>', methods=["GET"])
def get_all_users(columns):
    try:
        return jsonify(db_lib.filtered_query_all_rows("users", columns=columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to delete a record from the users table based on user ID
@app.route('/delete_from_users/<userID>', methods=["DELETE"])
def delete_from_users(userID):
    try:
        db_lib.delete_row("users", userID)
        return "Deleted Successfully"
    except AssertionError as e:
        raise AssertionError("Deleting an item failed due to {}".format(e))

# Route to update a record from the users table based on user ID
@app.route('/update_users/<userID>', methods=["PUT"])
def update_users(userID):
    param = request.json['param']
    new_val = request.json['new_val']
    try:
        db_lib.update_row("users", param, new_val, userID)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# --------- Routes for Module <-> Server <-> Items Occurrences Table Communication --------- #

# Route to add an entry into the items occurrences table
@app.route('/add_to_items_occurrences', methods=['POST'])
def add_to_items_occurrences():
    json = request.form
    entry = (json["ID"],
             json["Barcode"],
             json["User_UID"],
             json["Name"],
             json["Occurrences"])
    try:
        db_lib.insert_row("items_occurrences", entry)
        return "Added Successfully"
    except AssertionError as e:
        raise AssertionError(
            "Could not add to the database table due to {}".format(e))

# Route to return a record from the items occurrences table based on a barcode and user ID
@app.route('/get_from_items_occurrences/<int:barcode>/<userID>/<columns>', methods=["GET"])
def get_from_items_occurrences(barcode, userID, columns):
    try:
        return jsonify(db_lib.filtered_query_row("items_occurrences", barcode, userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return a record from the items occurrences table based on a condition
@app.route('/get_from_items_occurrences_based_on_condition/<condition>/<columns>', methods=["GET"])
def get_from_items_occurrences_based_on_condition(condition, columns):
    try:
        return jsonify(db_lib.filtered_query_based_on_condition("items_occurrences", condition, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return all records for a user via user ID from the items occurrences table
@app.route('/get_all_items_occurrences/<userID>/<columns>', methods=["GET"])
def get_all_items_occurences(userID, columns):
    try:
        return jsonify(db_lib.filtered_query_all_rows("items_occurrences", userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Delete a return a record from the items occurrences table based on a barcode and user ID
@app.route('/delete_from_items_occurrences/<int:barcode>/<userID>', methods=["DELETE"])
def delete_from_items_occurrences(barcode, userID):
    try:
        db_lib.delete_row("items_occurrences", barcode, userID)
        return "Deleted Successfully"
    except AssertionError as e:
        raise AssertionError("Deleting an item failed due to {}".format(e))

# Update a return a record from the items occurrences table based on a barcode and user ID
@app.route('/update_w_offset_items_occurrences/<int:barcode>/<userID>', methods=["PUT"])
def update_w_offset_items_occurrences(barcode, userID):
    param = request.form['param']
    offset = request.form['offset']
    try:
        db_lib.update_row_with_offset("items_occurrences", param, offset, barcode, userID)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# Update a return a record from the items occurrences table based on a barcode and user ID
@app.route('/update_items_occurrences/<int:barcode>/<userID>', methods=["PUT"])
def update_items_occurrences(barcode, userID):
    param = request.form['param']
    new_val = request.form['new_val']
    try:
        db_lib.update_row("items_occurrences", param, new_val, userID, barcode)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# --------- Routes for Module <-> Server <-> Users History Table Communication --------- #

# Route to add an entry into the users history table
@app.route('/add_to_users_history', methods=['POST'])
def add_to_users_history():
    json = request.form
    entry = (json["ID"],
             json["Date"],
             json["User_UID"],
             json["Net_Calories"],
             json["Net_Fat"],
             json["Net_Saturated"],
             json["Net_Polyunsaturated"],
             json["Net_Monounsaturated"],
             json["Net_Trans"],
             json["Net_Cholesterol"],
             json["Net_Sodium"],
             json["Net_Carbohydrate"],
             json["Net_Fiber"],
             json["Net_Protein"],
             json["Net_Sugars"],
             json["Net_Potassium"],
             json["Net_Vitamin_A"],
             json["Net_Vitamin_C"],
             json["Net_Calcium"],
             json["Net_Iron"])
    try:
        db_lib.insert_row("users_history", entry)
        return "Added Successfully"
    except AssertionError as e:
        raise AssertionError(
            "Could not add to the database table due to {}".format(e))

# Route to return a record from the users history table based on a date and user ID
@app.route('/get_from_users_history/<date>/<userID>/<columns>', methods=["GET"])
def get_from_users_history(date, userID, columns):
    try:
        return jsonify(db_lib.filtered_query_row("users_history", date, userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return a record from the users history table based on a condition
@app.route('/get_from_users_history_based_on_condition/<condition>/<columns>', methods=["GET"])
def get_from_users_history_based_on_condition(condition, columns):
    try:
        return jsonify(db_lib.filtered_query_based_on_condition("users_history", condition, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Route to return all records for a user via user ID from the users history table
@app.route('/get_all_users_history/<userID>/<columns>', methods=["GET"])
def get_all_users_history(userID, columns):
    try:
        return jsonify(db_lib.filtered_query_all_rows("users_history", userID, columns))
    except AssertionError as e:
        raise AssertionError(
            "Getting information of an item failed due to {}".format(e))

# Delete a return a record from the users history table based on a date and user ID
@app.route('/delete_from_users_history/<date>/<userID>', methods=["DELETE"])
def delete_from_users_history(date, userID):
    try:
        db_lib.delete_row("users_history", date, userID)
        return "Deleted Successfully"
    except AssertionError as e:
        raise AssertionError("Deleting an item failed due to {}".format(e))

# Update a return a record from the users history table based on a date and user ID
@app.route('/update_w_offset_users_history/<date>/<userID>', methods=["PUT"])
def update_w_offset_users_history(date, userID):
    param = request.form['param']
    offset = request.form['offset']
    try:
        db_lib.update_row_with_offset("users_history", param, offset, date, userID)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# Update a return a record from the users history table based on a date and user ID
@app.route('/update_users_history/<date>/<userID>', methods=["PUT"])
def update_users_history(date, userID):
    param = request.form['param']
    new_val = request.form['new_val']
    try:
        db_lib.update_row("users_history", param, new_val, userID, date)
        return 'Updated Successfully'
    except AssertionError as e:
        raise AssertionError("Updating an item failed due to {}".format(e))

# --------- Home Page --------- #

@app.route('/')
def home():
    return "Hosted"

if __name__ == '__main__':
    app.run()
