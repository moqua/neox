
include_class 'com.gargoylesoftware.htmlunit.util.WebConnectionWrapper'
include_class 'com.gargoylesoftware.htmlunit.IncorrectnessListenerImpl'
include_class 'com.gargoylesoftware.htmlunit.javascript.DebugFrameImpl'
include_class 'com.gargoylesoftware.htmlunit.javascript.DebuggerImpl'


class HookedWebConnection < WebConnectionWrapper
	def initialize(web_client)
		$list_requests = Array.new
		$list_redirects = Array.new
	end
	alias :super_getResponse :getResponse
	def getResponse(web_request)
		url = web_request.getUrl().toString()
		http_method = web_request.getHttpMethod().to_s
		$list_requests << [url,http_method]
		if $list_requests.length == 1
			puts '[+] loading: ' +http_method+ ' ' +url
		else
			puts '[+] +loading: ' +http_method+ ' ' +url
		end
		begin
			response = super_getResponse(web_request)
			header_status = response.getResponseHeaderValue('Status')
			if header_status.to_s.include? '301' or header_status.to_s.include? '302'

				$list_redirects << [url,http_method]
				puts '[+] is redirect to: ' +http_method+ ' ' +url
			else
			end
			
			# here we have a good response
			raw_content = response.getContentAsString()
			time_start = Time.now
			timestamp = time_start.strftime("%Y%m%d%H%M%S")
			md5 = Digest::MD5.hexdigest(raw_content)
			host = URI.parse(url).host
			logfile = File.new('out/'+timestamp+'_'+host+'_'+md5+'.response', 'w')
			logfile.write(raw_content)
			logfile.close()

			return response
		rescue Exception => msg
			puts '[-] getResponse() : ' +msg
			exit
		end
	end
	def getListRequests()
		return $list_requests
	end
	def getListRedirects()
		return $list_redirects
	end
end

class HookedIncorrectnessListener < IncorrectnessListenerImpl
   def notify(message, origin)
#     puts '[!] ' +message
   end
end

class HookedDebugFrameImpl < DebugFrameImpl
	def initialize(functionOrScript)
#		puts '[+] new frame generated'
		$function_or_script = functionOrScript
		$obj = Object.new
	end
	def getObj()
		return $obj
	end

	# onEnter == new line
	def onEnter(cx,activation,obj,args)
		puts '[+] debug frame onEnter'
		$obj = obj
		js_var_mem_usage = 0

		puts '[+] objectClassName: ' +obj.getClassName()
		alias :super_getFunctionName :getFunctionName
		puts '[+] function called: ' +super_getFunctionName(obj)
		for i in args:
			puts '[+]   arg:' +i.to_s
		end
		scope = cx.initStandardObjects(obj) # only with obj js variables !Global
		id_prop_array = scope.getIds() # getAllIds() includes HTML objects
		for js_variable in id_prop_array
#			js_value = cx.toString(js_variable)
			x = scope.get(js_variable)
			js_value = x.to_s
			begin
			js_value = cx.toString(x)
			rescue
			end
#			js_value = cx.evaluateString(scope, "return "+js_variable.to_s, "<cmd>", 1, null)
			js_var_mem_usage += js_value.length

			# filter
			if js_value.index("com.gargoylesoftware.htmlunit.javascript")!=0 && js_value.length!=0
				$js_dom_objects << [js_variable,js_value]
#				puts '[+] js_var = js_val : "' +js_variable+ '" == "' +js_value+ '"' 
			end
		end

		$js_dom_objects = $js_dom_objects.uniq
		puts '[+] js var + func mem usage: ' +js_var_mem_usage.to_s+ ' bytes'
		puts '[+] debug frame end'
		puts ''

		super(cx,activation,obj,args)
	end

	def onLineChange(cx,lineNumber)
#		puts '[+] newline nr: ' +lineNumber.to_s
		super(cx,lineNumber)
	end

	def self.getFunctionName(obj)
		function_name = superclass.getFunctionName(obj)
		puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!' +function_name.to_s
		return function_name
	end

	def onExceptionThrown(cx,t)
		$js_exec_errors << [1]
		super(cx,t)
	end
end

class HookedDebuggerImpl < DebuggerImpl
	def handleCompilationDone(cx,functionOrScript,source)
		puts '[+] enter handleCompilationDone'
#		puts '[+] functionOrScript info'
		$function_or_script = functionOrScript
#		if $function_or_script.isGeneratedScript()
#			'[+] runtime generated function or script!'
#		end
		if $function_or_script.isFunction()
#			puts '[+] function called: ' +$function_or_script.getFunctionName()+ '()' +' with ' +$function_or_script.getParamCount().to_s+ ' arguments'
#			puts '[+] number of args+variables ' +$function_or_script.getParamAndVarCount().to_s
#			for i in (0..$function_or_script.getParamAndVarCount()-1)
#				puts '[+]    function param name ' +i.to_s+ ': "' +$function_or_script.getParamOrVarName(i)+ '"'
#			end
		else
			puts '[+] script called'
			puts '[+] num global variables: ' +$function_or_script.getParamAndVarCount().to_s
			for i in (0..$function_or_script.getParamAndVarCount()-1)
#				puts '[+]     script variable ' +i.to_s+ ': "' +$function_or_script.getParamOrVarName(i)+ '"'
				$js_global_vars << [$function_or_script.getParamOrVarName(i)]
			end
		end
	end
	def getFrame(cx,functionOrScript) # from Debugger
		frame = HookedDebugFrameImpl.new(functionOrScript)
#		frame = DebugFrameImpl.new(functionOrScript)
#		puts '[+] got frame with id: ' +frame.object_id.to_s
		return frame
	end
end
