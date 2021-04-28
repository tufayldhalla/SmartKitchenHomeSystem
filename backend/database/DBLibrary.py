import mysql.connector
import os
import datetime


class DBLibrary:
    def __init__(self):
        # Parameters to be able to connect to AWS RDS
        self.config = {
            'user': 'admin',
            'password': 'modules_never_die42069',
            'host': 'smartkitchenidentifier.crmhddehtptk.us-east-2.rds.amazonaws.com',
            'port': '3306',
            'database': 'SmartKitchenDB',
            'raise_on_warnings': True,
        }

        # Table to store food products and their nutritional information
        # Primary key indicates this value will be unique in the table - used as our identifier
        # Not null indicates the a value must be entered for that field
        # Weight type units are: millimeters, grams, ounces, cups, and count
        self.product_table_schema = "CREATE TABLE IF NOT EXISTS products (" \
                                    "Barcode BIGINT PRIMARY KEY, " \
                                    "Name TEXT NOT NULL, " \
                                    "Weight FLOAT NOT NULL, " \
                                    "Weight_Type ENUM ('mL', 'g', 'oz', 'cup', 'count') NOT NULL, " \
                                    "Calories FLOAT NOT NULL, " \
                                    "Fat FLOAT NOT NULL, " \
                                    "Saturated FLOAT NOT NULL, " \
                                    "Polyunsaturated FLOAT NOT NULL, " \
                                    "Monounsaturated FLOAT NOT NULL, " \
                                    "Trans FLOAT NOT NULL, " \
                                    "Cholesterol FLOAT NOT NULL, " \
                                    "Sodium FLOAT NOT NULL, " \
                                    "Carbohydrate FLOAT NOT NULL, " \
                                    "Fiber FLOAT NOT NULL, " \
                                    "Protein FLOAT NOT NULL, " \
                                    "Sugars FLOAT NOT NULL, " \
                                    "Potassium FLOAT NOT NULL, " \
                                    "Vitamin_A FLOAT NOT NULL, " \
                                    "Vitamin_C FLOAT NOT NULL, " \
                                    "Calcium FLOAT NOT NULL, " \
                                    "Iron FLOAT NOT NULL)"

        # Tables of registered firebase users
        self.users_table_schema = "CREATE TABLE IF NOT EXISTS users (" \
                                  "User_UID VARCHAR(200) PRIMARY KEY, " \
                                  "Email TEXT NOT NULL, " \
                                  "First_Name TEXT NOT NULL, " \
                                  "Last_Name TEXT NOT NULL," \
                                  "Gender ENUM ('Male', 'Female', 'Prefer Not to Say')," \
                                  "Date_of_Birth DATE," \
                                  "Calorie_Goal FLOAT," \
                                  "Protein_Goal FLOAT," \
                                  "Carbohydrate_Goal FLOAT," \
                                  "Fat_Goal FLOAT," \
                                  "QR_Code VARCHAR(512)," \
                                  "Profile_Picture VARCHAR(512))"

        # Table for storing inventory of all registered users
        # Expiration date is in the format YYYY-MM-DD
        # Scanned is for the module to determine what items are on the module (in) vs what items are in use (out)
        self.users_inventory_table_schema = "CREATE TABLE IF NOT EXISTS users_inventory (" \
                                            "ID INT PRIMARY KEY AUTO_INCREMENT, " \
                                            "Barcode BIGINT NOT NULL, " \
                                            "User_UID VARCHAR(200) NOT NULL, " \
                                            "Name TEXT NOT NULL, " \
                                            "Measured_Weight FLOAT, " \
                                            "Weight FLOAT NOT NULL, " \
                                            "Weight_Type ENUM ('mL', 'g', 'oz', 'cup', 'count') NOT NULL, " \
                                            "Expiration_Date DATE," \
                                            "Scanned ENUM ('in', 'out'), "\
                                            "Count INT)"

        # Table for storing number of occurrences of items for all registered users
        # Used when recommending groceries the user should buy
        self.items_occurrences_table_schema = "CREATE TABLE IF NOT EXISTS items_occurrences (" \
                                              "ID INT PRIMARY KEY AUTO_INCREMENT, " \
                                              "Barcode BIGINT NOT NULL, " \
                                              "User_UID VARCHAR(200) NOT NULL, " \
                                              "Name TEXT NOT NULL, " \
                                              "Occurrences INT NOT NULL)"

        # Table for storing daily nutritional intake for all registered users
        self.users_history_table_schema = "CREATE TABLE IF NOT EXISTS users_history (" \
                                          "ID INT PRIMARY KEY AUTO_INCREMENT, " \
                                          "Date DATE NOT NULL, " \
                                          "User_UID VARCHAR(200) NOT NULL, " \
                                          "Net_Calories FLOAT , " \
                                          "Net_Fat FLOAT, " \
                                          "Net_Saturated FLOAT, " \
                                          "Net_Polyunsaturated FLOAT, " \
                                          "Net_Monounsaturated FLOAT, " \
                                          "Net_Trans FLOAT, " \
                                          "Net_Cholesterol FLOAT, " \
                                          "Net_Sodium FLOAT, " \
                                          "Net_Carbohydrate FLOAT, " \
                                          "Net_Fiber FLOAT, " \
                                          "Net_Protein FLOAT, " \
                                          "Net_Sugars FLOAT, " \
                                          "Net_Potassium FLOAT, " \
                                          "Net_Vitamin_A FLOAT, " \
                                          "Net_Vitamin_C FLOAT, " \
                                          "Net_Calcium FLOAT, " \
                                          "Net_Iron FLOAT)"

    def create_table(self):
        """
        Create a table
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            # Create a table - remove comment based on the table to be created
            #cur.execute(self.product_table_schema)
            #cur.execute(self.users_table_schema)
            cur.execute(self.users_inventory_table_schema)
            #cur.execute(self.items_occurrences_table_schema)
            #cur.execute(self.users_history_table_schema)
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def __drop_table(self, table_name):
        """
        Drop a table
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            # Drop a table
            cur.execute(f"DROP TABLE IF EXISTS {table_name}")
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def __list_tables_in_db(self):
        """
        Returns a list of all the tables in the DB
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            # Gets all tables in db
            cur.execute("SHOW TABLES IN SmartKitchenDB")
            tables = cur.fetchall()
            conn.close()  # close connection to db
            return tables
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def insert_row(self, table_name, data):
        """
        Inserts a row into the desired table
        :param table_name: the table desired to insert a row to
        :param data: is the list of information to add to the table in a tuple format
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            # Creates a row and inserts data into row
            # execute command
            if table_name == "users_inventory":
                # Check if the data has already been added to the users inventory
                check = self.filtered_query_row("users_inventory", int(data[1]), str(data[2]))
                # if no the add to users inventory
                if check == None:
                    cur.execute(f"INSERT INTO {table_name} VALUES {data}")
                # else increment count
                else:
                    self.update_row_with_offset("users_inventory", "Count", 1, int(data[1]), str(data[2]))
                    self.update_row_with_offset("users_inventory", "Weight", int(data[5]), int(data[1]), str(data[2]))
            else:
                cur.execute(f"INSERT INTO {table_name} VALUES {data}")
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def update_row_with_offset(self, table_name, param, offset, bar_or_date, user_uid):
        """
        Updates information in a row into the desired table
        :param user_uid: user unique identifier
        :param bar_or_date: Barcode of the product or the Date which the row needs to be updated
        :param offset: How much to increment/decrement the parameter by (could be a positive or negative number)
        :param param: The parameter by which needs to be updated in the table
        :param table_name: The table desired to insert a row to
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            # Updates a row with an offset
            if table_name == "users_history":
                cur.execute(
                    f"UPDATE {table_name} SET {param} = {param} + {offset} WHERE Date = '{bar_or_date}' AND User_UID = '{user_uid}'")
            else:
                cur.execute(
                    f"UPDATE {table_name} SET {param} = {param} + {offset} WHERE Barcode = {bar_or_date} AND User_UID = '{user_uid}'")
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def update_row(self, table_name, param, new_val, user_uid, bar_or_date=""):
        """
        Updates information in a row into the desired table
        :param user_uid: user unique identifier
        :param bar_or_date: Barcode of the product or the Date which the row needs to be updated
        :param new_val: New value to replace old value
        :param param: The parameter by which needs to be updated in the table
        :param table_name: The table desired to insert a row to
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            if isinstance(new_val, str):
                new_val = "'" + new_val + "'"
            # Updates a row
            if table_name == "users":
                cur.execute(f"UPDATE {table_name} SET {param} = {new_val} WHERE User_UID = '{user_uid}'")
            elif table_name == "users_history":
                cur.execute(f"UPDATE {table_name} SET {param} = {new_val} WHERE Date = '{bar_or_date}' AND User_UID = '{user_uid}'")
            else:
                cur.execute(f"UPDATE {table_name} SET {param} = {new_val} WHERE Barcode = {bar_or_date} AND User_UID = '{user_uid}'")
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def update_macros_in_user_history(self, date, user_uid, barcode, offset):
        """
        Updates all the nutritional information in a users history row based on a date for a specific user
        :param user_uid: user unique identifier
        :param barcode: Barcode of the product
        :param date: Date which the row needs to be updated
        :param offset: The parameter by which needs to be updated in the table
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute command
            nutrition = self.filtered_query_row("products", barcode)

            cur.execute(f"UPDATE users_history SET Net_Calories = Net_Calories + {offset * nutrition['Calories']}, Net_Fat = Net_Fat + {offset * nutrition['Fat']}, Net_Saturated = Net_Saturated + {offset * nutrition['Saturated']}, Net_Polyunsaturated = Net_Polyunsaturated + {offset * nutrition['Polyunsaturated']}, Net_Monounsaturated = Net_Monounsaturated + {offset * nutrition['Monounsaturated']}, Net_Trans = Net_Trans + {offset * nutrition['Trans']}, Net_Cholesterol = Net_Cholesterol + {offset * nutrition['Cholesterol']}, Net_Sodium = Net_Sodium + {offset * nutrition['Sodium']}, Net_Carbohydrate = Net_Carbohydrate + {offset * nutrition['Carbohydrate']}, Net_Fiber = Net_Fiber + {offset * nutrition['Fiber']}, Net_Protein = Net_Protein + {offset * nutrition['Protein']}, Net_Sugars = Net_Sugars + {offset * nutrition['Sugars']}, Net_Potassium = Net_Potassium + {offset * nutrition['Potassium']}, Net_Vitamin_A = Net_Vitamin_A + {offset * nutrition['Vitamin_A']}, Net_Vitamin_C = Net_Vitamin_C + {offset * nutrition['Vitamin_C']}, Net_Calcium = Net_Calcium + {offset * nutrition['Calcium']}, Net_Iron = Net_Iron + {offset * nutrition['Iron']} WHERE Date = '{date}' AND User_UID = '{user_uid}'")

            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def delete_row(self, table_name, bar_or_date="", user_uid=""):
        """
        Deletes an row from a specific table based on a barcode
        :param table_name: name of the table
        :param bar_or_date: The barcode of the product or the Date which the row needs to be updated
        :param user_uid: user unique identifier
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            cur = conn.cursor()  # define cursor to execute commands
            if table_name == "users":
                cur.execute(f"DELETE from {table_name} WHERE User_UID = '{user_uid}'")
            elif table_name == "products":
                cur.execute(f"DELETE from {table_name} WHERE Barcode={bar_or_date}")
            elif table_name == "users_history":
                cur.execute(f"DELETE from {table_name} WHERE Date='{bar_or_date}' AND User_UID = '{user_uid}'")
            else:
                # Check if the data has only 1 count in the users inventory
                check = self.filtered_query_row("users_inventory", bar_or_date, user_uid)
                # if only 1 users inventory then delete
                if check["Count"] == 1:
                    cur.execute(f"DELETE from {table_name} WHERE Barcode={bar_or_date} AND User_UID = '{user_uid}'")
                # else if greater than 1 then decrement count
                elif check["Count"] > 1:
                    self.update_row_with_offset("users_inventory", "Count", -1, bar_or_date, user_uid)
                    if check["Scanned"] == 'out':
                        self.update_row("users_inventory", "Scanned", 'in', user_uid, bar_or_date)
            conn.commit()  # save changes
            conn.close()  # close connection to db
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def filtered_query_row(self, table_name, bar_or_date="", user_uid="", columns="*"):
        """
        Returns a particular row from a specific table based on the barcode number of the product and user uid, but columns are dependent on input
        :param columns: list without brackets columns that wants to be returned, * is default
        :param table_name: name of the table
        :param bar_or_date: The barcode of the product or the Date which the row needs to be updated
        :param user_uid: user unique identifier
        :return: The row which the barcode corresponds to what was given
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            # define cursor to execute commands
            cur = conn.cursor(dictionary=True)
            # Query row and only returns that desired columns
            if table_name == "users":
                cur.execute(
                    f"SELECT {columns} from {table_name} WHERE User_UID = '{user_uid}'")
            elif table_name == "products":
                cur.execute(
                    f"SELECT {columns} from {table_name} WHERE Barcode={bar_or_date}")
            elif table_name == "users_history":
                cur.execute(
                    f"SELECT {columns} from {table_name} WHERE Date='{bar_or_date}' AND User_UID = '{user_uid}'")
            else:
                cur.execute(
                    f"SELECT {columns} from {table_name} WHERE Barcode={bar_or_date} AND User_UID = '{user_uid}'")
            row = cur.fetchone()  # fetch one row
            conn.close()  # close connection to db
            return row
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def filtered_query_based_on_condition(self, table_name, condition, columns="*"):
        """
        Returns a particular row from a specific table based on the barcode number of the product and user uid, but columns are dependent on input
        :param columns: list without brackets columns that wants to be returned, * is default
        :param table_name: name of the table
        :param condition: query based on condition
        :param user_uid: user unique identifier
        :return: The row which the barcode corresponds to what was given
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            # define cursor to execute commands
            cur = conn.cursor(dictionary=True)
            # Query row and only returns that desired columns
            cur.execute(
                f"SELECT {columns} from {table_name} WHERE {condition}")
            row = cur.fetchall()  # fetch all rows
            conn.close()  # close connection to db
            return row
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))

    def filtered_query_all_rows(self, table_name, user_uid="", columns="*"):
        """
        Return all entries from a table but columns are dependent on input
        :param columns: list without brackets columns that wants to be returned, * is default
        :param table_name: name of the table
        :param user_uid: user unique identifier
        :return: the whole table (all rows)
        """
        try:
            conn = mysql.connector.connect(**self.config)  # connect to db
            # define cursor to execute commands
            cur = conn.cursor(dictionary=True)
            # Query all rows and only returns that desired columns
            if table_name == "products" or table_name == "users":
                cur.execute(f"SELECT {columns} from {table_name}")
            else:
                cur.execute(
                    f"SELECT {columns} from {table_name} WHERE User_UID = '{user_uid}'")
            rows = cur.fetchall()  # fetch all rows
            conn.close()  # close connection to db
            return rows
        except Exception as e:
            raise ValueError("Failed due to {}".format(e))


if __name__ == '__main__':
    db_test = DBLibrary()
    product_entry_example = ("4746553", "Burgers", 1000, 'g', 230,
                             5.6, 43, 43, 21, 4, 543, 54, 4.6, 0, 0, 0, 0, 0, 0, 0, 0)
    # db_test.drop_table("items_occurrences")
    # db_test.drop_table("users")
    # db_test.drop_table("users_history")
    # db_test.drop_table("users_inventory")
    # db_test.create_table()
    # data = (0, 75675445, "ACIQ8qYFXqRmJAbzQgPGrcfoQ4a2", "Rice", 0, 200, 'g', datetime.date(2022, 5, 19).strftime('%Y-%m-%d'), 'in')
    # db_test.insert_row("users_inventory", data)
