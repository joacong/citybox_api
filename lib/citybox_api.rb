require "citybox_api/version"
require 'rest-client'
require 'crack'

require 'citybox_api/regions'
require 'citybox_api/branch_offices'
require 'citybox_api/configuration'
require "citybox_api/shipments"

module CityboxApi
  	# Credentials for API
	INVALID_CREDENTIALS = "Key cant be blank!"
  	CityboxApi.configure

  	def self.catch_error error
  		puts error
  		json_response = Crack::XML.parse(error.response)
		fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
		fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
		fault = {faultCode: fault_code, fault_string: fault_string}
		puts fault
		return nil
  	end
end
