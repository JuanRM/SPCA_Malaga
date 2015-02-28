# Include the Dropbox SDK libraries
require 'dropbox_sdk'


# Get your app key and secret from the Dropbox developer website
APP_KEY = "yvq7ku3kzdjyjs8"
APP_SECRET = "z080bdwkempegnf"
ACCESS_TYPE = "App folder"

session = DropboxSession.new(APP_KEY, APP_SECRET) 
