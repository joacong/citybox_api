require "citybox_api/version"
require 'rest-client'
require 'crack'

require 'citybox_api/regions'
require 'citybox_api/branch_offices'
require 'citybox_api/configuration'
require "citybox_api/admissions"

module CityboxApi
  	# Credentials for API
	INVALID_CREDENTIALS = "Key cant be blank!"
  	CityboxApi.configure
end
