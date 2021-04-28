import requests

class APILibrary:

    def __init__(self):
        self.server_url = 'https://smart-kitchen-module.herokuapp.com/'

    def get_product(self, barcode, columns="*"):
        """ API to return a record from the products database based on a barcode """
        try:
            response = requests.get(self.server_url + 'get_product/' + barcode + '/' + columns)
            return response.json()
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def remove_from_inventory(self, barcode, userID):
        """ API to remove an entry from the users inventory table """
        try:
            response = requests.delete(self.server_url + 'delete_from_user_inventory/' + barcode + '/' + userID)
            return response
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def update_in_inventory_w_offset(self, barcode, userID, param, offset):
        """ API to update an entry in the users inventory with an offset """
        data = {'param': param, 'offset': offset}
        try:
            response = requests.put(self.server_url + 'update_w_offset_user_inventory/' + barcode + '/' + userID, data)
            return response
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def update_in_inventory(self, barcode, userID, param, new_val):
        """ API to update an entry in the users inventory with a new value """
        data = {'param': param, 'new_val': new_val}
        try:
            response = requests.put(self.server_url + 'update_user_inventory/' + barcode + '/' + userID, data)
            return response
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def get_from_inventory(self, barcode, userID, columns="*"):
        """ API to get an entry from the users inventory """
        try:
            response = requests.get(self.server_url + 'get_from_user_inventory/' + barcode + '/' + userID + '/' + columns)
            return response.json()
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def get_all_from_inventory(self, barcode, columns="*"):
        """ API to get all entries from the users inventory """
        try:
            response = requests.get(self.server_url + 'get_all_user_inventory/' + barcode + '/' + columns)
            return response.json()
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))
    
    def get_from_users(self, userID, columns="*"):
        """ API to get a user from the users table """
        try:
            response = requests.get(self.server_url + 'get_from_users/' + userID + '/' + columns)
            return response.json()
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))

    def get_all_from_users(self, columns="*"):
        """ API to get all users from the users table """
        try:
            response = requests.get(self.server_url + 'get_all_users/' + columns)
            return response.json()
        except AssertionError as e:
            raise AssertionError("Error due to {}".format(e))