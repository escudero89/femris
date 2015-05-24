# -*- coding: utf-8 -*-

# To look for binaries
import mimetypes

# My own files
import content
from utils import *  # Utils module

# To solve problems with codification
import sys
reload(sys)
sys.setdefaultencoding("utf-8")

# 1er. Chequear que estamos en la carpeta hija de femris.exe
# 2do. Chequear el tag actual de release de binary y resources
# 3ro. Chequear online los ultimos tags.
# 4to.
#   a) Si son iguales, no hacer nada.
#   b) Si difieren, y son version mas alta la descargada, informar y salir.
#   c) Si difieren, y es version mas baja la descargada:
#       resources -> bajar version nueva y reemplazar resources anteriores.
#       binary -> (linux) bajar y reemplazar ; (windows) informar.

class GithubHandler:

    curr_tag_offline = False

    update_binary = {
        'tag' : False,
        'url' : False
    }

    update_resources = {
        'tag' : False,
        'url' : False
    }

    def we_are_in_the_correct_spot(self):
        if not self.check_binary_exists():
            print colorize(content.warning["wrong_folder"], 'FAIL')
            exit(content.error_codes['we_are_in_the_correct_spot'])

    def check_binary_exists(self):
        if self.os_name == "Linux":
            femris_path = "../femris"
            looked_mime = None
        else:
            femris_path = "../femris.exe"
            looked_mime = 'application/x-msdos-program'

        return self.check_binary_exists_helper(femris_path, looked_mime)

    def check_binary_exists_helper(self, femris_path, looked_mime):
        file_exists(femris_path)
        return mimetypes.guess_type(femris_path)[0] == looked_mime

    def get_current_tag_offline(self):
        return json.loads(get_file_contents('current.json'))

    def get_current_tag_online(self):
        """
        Here we are going to check for updates in binaries or in resources.
         To do it so, we are going to compare the tags that are published
         online with those that we have offline.
        :return:True if we need to update; False otherwise.
        """

        json_release = get_json_online(content.github['releases'])

        # We define what would be our next tag
        previous_item = json_release[0]

        next_tag = {
            'binary_tag': False,
            'binary_pos': 0,
            'resources_tag': False,
            'resources_pos': 0
        }

        # We search in the list for our current tag first
        for idx, item in enumerate(json_release):
            if self.curr_tag_offline['binary_tag'] == item['tag_name']:
                next_tag['binary_tag'] = previous_item['tag_name']
                next_tag['binary_pos'] = max(idx - 1, 0)

            if self.curr_tag_offline['resources_tag'] == item['tag_name']:
                next_tag['resources_tag'] = previous_item['tag_name']
                next_tag['resources_pos'] = max(idx - 1, 0)

            previous_item = item

        # Then we check if we actually need to update
        if self.curr_tag_offline['binary_tag'] < next_tag['binary_tag']:
            ref = 'exe' if self.os_name == "Windows" else 'bin'
            ref += self.architecture_sz

            self.update_binary['tag'] = next_tag['binary_tag']
            self.update_binary['url'] = \
                content.github[ref] % next_tag['resources_tag']

            # And we inform about it
            print_binary = [
                content.es["update_binary"] % next_tag['binary_tag'],
                "> " + content.os[self.os_name]["update_binary"]
            ]
            print colorize(print_binary[0], 'BLUE')
            print colorize(print_binary[1], 'WARNING')
            return True

        # We also check for changes in the resources
        elif self.curr_tag_offline['resources_tag'] < next_tag['resources_tag']:
            self.update_resources['tag'] = next_tag['resources_tag']
            self.update_resources['url'] = \
                content.github['zip'] % next_tag['resources_tag']

            # And we inform about it
            print_resources = [
                content.es["update_resources"] % next_tag['resources_tag'],
                "> " + content.os[self.os_name]["update_resources"]
            ]
            print colorize(print_resources[0], 'BLUE')
            print colorize(print_resources[1], 'WARNING')
            return True

        # If nothing changed...
        print colorize(content.es["without_changes"], 'BLUE')
        return False

    def get_update_status(self):
        """
        Main function to call to recall the status of update of femris.
        :return:True if we need to update; False otherwise.
        """
        self.curr_tag_offline = self.get_current_tag_offline()
        return self.get_current_tag_online()

    def __init__(self, os_name, architecture_sz):

        if os_name != "Linux" and os_name != "Windows":
            raise NotImplementedError(content.warning["os"])

        self.os_name = os_name
        self.architecture_sz = architecture_sz

        self.we_are_in_the_correct_spot()
        print colorize(content.es["right_location"], 'HEADER')



github_handler = GithubHandler('Linux', '64')
print github_handler.get_update_status()