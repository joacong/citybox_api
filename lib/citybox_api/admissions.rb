module CityboxApi
	# module for admissions services
	class Admissions
		def initialize
			raise CityboxApi::INVALID_CREDENTIALS if CityboxApi.configuration.key == nil
	  		@server_url = "http://b2b.correos.cl:8008/ServicioAdmisionCEPExterno/cch/ws/enviosCEP/externo/implementacion/ServicioExternoAdmisionCEP.asmx"
	  		@user = CityboxApi.configuration.user
	  		@password = CityboxApi.configuration.key
		end

		# sent an allow shipping request
		def allow_shipping opts={}
			#default values
			opts[:sender_country] ||= "056" #chile
			opts[:receiver_country] ||= "056" #chile
			opts[:declared_import_value] ||= "NO"
			opts[:destination_email] ||= "NO"
			opts[:success_return] ||= "N"
			opts[:documents_number] ||= 0
			opts[:secure_payment] ||= "N"

			#check params
			[
				:admission_id, :sender_code, :sender_street, :sender_commune, :sender_contact_person, :receiver_name,
				:receiver_street, :receiver_commune, :service_code, :pieces_number, :kilograms, :reference_number,
				:declared_import_value, :payment_type
			].each{|p| raise "#{p} can't be blank" unless opts[p]}


		  	xml = "<?xml version='1.0' encoding='utf-8'?>
					<soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'>
					  <soap:Body>
					    <admitirEnvio xmlns='http://tempuri.org/'>
					      <usuario>#{@user}</usuario>
					      <contrasena>#{@password}</contrasena>
					      <admisionTo>
					        <ExtensionData />
					        <CodigoAdmision>#{opts[:admission_id]}</CodigoAdmision>
					        <ClienteRemitente>#{opts[:sender_code]}</ClienteRemitente>
					        <CentroRemitente></CentroRemitente>
					        <NombreRemitente>#{opts[:sender_name]}</NombreRemitente>
					        <DireccionRemitente>#{opts[:sender_street]}</DireccionRemitente>
					        <PaisRemitente>#{opts[:sender_country]}</PaisRemitente>
					        <CodigoPostalRemitente></CodigoPostalRemitente>
					        <ComunaRemitente>#{opts[:sender_commune]}</ComunaRemitente>
					        <RutRemitente>#{opts[:sender_rut]}</RutRemitente>
					        <PersonaContactoRemitente>#{opts[:sender_contact_person]}</PersonaContactoRemitente>
					        <TelefonoContactoRemitente>#{opts[:sender_contact_phone]}</TelefonoContactoRemitente>
					        <ClienteDestinatario></ClienteDestinatario>
					        <CentroDestinatario></CentroDestinatario>
					        <NombreDestinatario>#{opts[:receiver_name]}</NombreDestinatario>
					        <DireccionDestinatario>#{opts[:receiver_street]}</DireccionDestinatario>
					        <PaisDestinatario>#{opts[:receiver_country]}</PaisDestinatario>
					        <CodigoPostalDestinatario></CodigoPostalDestinatario>
					        <ComunaDestinatario>#{opts[:receiver_commune]}</ComunaDestinatario>
					        <RutDestinatario>#{opts[:receiver_rut]}</RutDestinatario>
					        <PersonaContactoDestinatario>#{opts[:receiver_contact_person]}</PersonaContactoDestinatario>
					        <TelefonoContactoDestinatario>#{opts[:receiver_contact_phone]}</TelefonoContactoDestinatario>
					        <CodigoServicio>#{opts[:service_code]}</CodigoServicio>
					        <NumeroTotalPiezas>#{opts[:pieces_number]}</NumeroTotalPiezas>
					        <Kilos>#{opts[:kilograms]}</Kilos>
					        <Volumen>#{opts[:volume]}</Volumen>
					        <NumeroReferencia>#{opts[:reference_number]}</NumeroReferencia>
					        <ImporteReembolso></ImporteReembolso>
					        <ImporteValorDeclarado>#{opts[:declared_import_value]}</ImporteValorDeclarado>
					        <TipoPortes>#{opts[:payment_type]}</TipoPortes>
					        <Observaciones>#{opts[:observations]}</Observaciones>
					        <Observaciones2></Observaciones2>
					        <EmailDestino>#{opts[:destination_email]}</EmailDestino>
					        <TipoMercancia>#{opts[:commodity_type]}</TipoMercancia>
					        <DevolucionConforme>#{opts[:success_return]}</DevolucionConforme>
					        <NumeroDocumentos>#{opts[:documents_number]}</NumeroDocumentos>
					        <PagoSeguro>#{opts[:secure_payment]}</PagoSeguro>
					      </admisionTo>
					    </admitirEnvio>
					  </soap:Body>
					</soap:Envelope>"

			begin
				xml_response = RestClient.post @server_url, xml, content_type: "text/xml"
				json_response = Crack::XML.parse(xml_response)
				json_response["soap:Envelope"]["soap:Body"]["admitirEnvioResponse"]["admitirEnvioResult"]
			rescue => e
				puts e
				return nil
			end
		end
	end
end