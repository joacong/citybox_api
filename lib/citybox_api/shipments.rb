module CityboxApi
	# module for shipments services
	class Shipments
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@server_url = "http://b2b.correos.cl:8008/ServicioAnulacionExterno/cch/ws/enviosCEP/externo/implementacion/ServicioExternoAnulacionEnvio.asmx"
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end

		def cancel_shipment opts={}

			#check params
			[
				:shipment_number, :admission_code, :sender_code
			].each{|p| raise "#{p} can't be blank" unless opts[p]}


			xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <anularEnvio xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <numeroEnvio>#{opts[:shipment_number]}</numeroEnvio>
					      <codigoAdmision>#{opts[:admission_code]}</codigoAdmision>
					      <clienteRemitente>#{opts[:sender_code]}</clienteRemitente>
					    </anularEnvio>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["anularEnvioResponse"]["anularEnvioResult"]
			rescue => error
				json_response = Crack::XML.parse(error.response)
				fault_code = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultcode"]
				fault_string = json_response["soap:Envelope"]["soap:Body"]["soap:Fault"]["faultstring"]
				fault = {faultCode: fault_code, fault_string: fault_string}
				puts fault
				return nil
			end
		end
	end
end