# To look for binaries
import mimetypes

# My own files
import content
from utils import *  # Utils module

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

    update_binary = False
    update_resources = False

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

        json_release = get_json_online(content.github["releases"])

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
        if self.curr_tag_offline['binary_tag'] == next_tag['binary_tag']:
            self.update_binary = True
            print "Necesitamos updatear binario"

        if self.curr_tag_offline['resources_tag'] == next_tag['resources_tag']:
            self.update_resources = True
            print "Necesitamos updatear resources"
        print next_tag
        json_assets = get_json_online(json_release[0]['assets_url'])

        #if len(json_assets[0]["assets"]) == 0:



    def __init__(self, os_name):
        self.os_name = os_name

        if os_name != "Linux" and os_name != "Windows":
            raise NotImplementedError(content.warning["os"])

        self.we_are_in_the_correct_spot()
        print "Femris encontrado"

        self.curr_tag_offline = self.get_current_tag_offline()
        self.curr_tag_online = self.get_current_tag_online()


github_handler = GithubHandler('Linux')
