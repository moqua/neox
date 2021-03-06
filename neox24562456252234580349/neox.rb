#
# find infected websites
#


require 'java'
require 'time'
require 'tempfile'
require 'digest/md5'

require 'src/2.8/htmlunit-2.8/target/htmlunit-2.9-SNAPSHOT.jar'
require 'src/2.8/core-js/target/htmlunit-core-js-2.8.jar'
require 'src/loggger/loggger.jar'

require 'neox_hooked.rb'

require 'apache-mime4j-0.6.jar'
require 'commons-codec-1.4.jar'
require 'commons-collections-3.2.1.jar'
require 'commons-io-1.4.jar'
require 'commons-lang-2.4.jar'
require 'commons-logging-1.1.1.jar'
require 'cssparser-0.9.5.jar'
require 'httpclient-4.0.1.jar'
require 'httpcore-4.0.1.jar'
require 'httpmime-4.0.1.jar'
require 'nekohtml-1.9.14.jar'
require 'sac-1.3.jar'
require 'serializer-2.7.1.jar'
require 'xalan-2.7.1.jar'
require 'xercesImpl-2.9.1.jar'
require 'xml-apis-1.3.04.jar'

require 'uri'

include_class 'java.net.URL'
include_class 'com.gargoylesoftware.htmlunit.WebClient'
include_class 'com.gargoylesoftware.htmlunit.WebWindow'
include_class 'com.gargoylesoftware.htmlunit.WebWindowListener'
include_class 'com.gargoylesoftware.htmlunit.WebRequestSettings'
include_class 'com.gargoylesoftware.htmlunit.BrowserVersion'
include_class 'com.gargoylesoftware.htmlunit.HttpWebConnection'

include_class 'com.gargoylesoftware.htmlunit.html.DomNode'
include_class 'com.gargoylesoftware.htmlunit.html.DomChangeListener'

include_class 'com.gargoylesoftware.htmlunit.javascript.JavaScriptEngine'
include_class 'com.gargoylesoftware.htmlunit.ScriptPreProcessor'

include_class 'loggger.CoreJSLoggger'
include_class 'loggger.CoreJSExceptionLoggger'
include_class 'loggger.HtmlunitLoggger'
include_class 'loggger.HtmlunitActiveXLoggger'

# java org.mozilla.javascript.tools.shell.Main beautify-cl.js
# rhino beautify-cl.js

def prepare_js_preprocessor()

	# js preprocessor
	$js_exec_count = 0
	$js_exec_max_size = 0
	$js_exec_comulated_size = 0
	$js_exec_source = Array.new()

	# js global DOM objects
	$js_dom_objects = Array.new()
	$js_global_vars = Array.new()
	$js_exec_errors = Array.new()

	js_preprocessor = ScriptPreProcessor.new()
	def js_preprocessor.preProcess(page,source,name,lineNumber,element)
		puts "[+] preprocessor script exec \n" +source
		$js_exec_source << source
		$js_exec_count += 1
		if source.length > $js_exec_max_size
			$js_exec_max_size = source.length
		end
		$js_exec_comulated_size += source.length

		# inject.js
		data = ''
		f = File.open("inject.js", "r") 
		f.each_line do |line|
			data += line
		end
		source = data+source
		return source
	end

	return js_preprocessor

end

def prepare_window_listener()
	# window listener (interface, no class!)
	window_listener = WebWindowListener.new()
	def window_listener.webWindowContentChanged(event)
		page = event.getNewPage()
		puts '[+] window content changed'
	end

	return window_listener
end

def prepare_dom_change_listener()
	# domchangelistener (interface, no class!)
	dom_change_listener = DomChangeListener.new()
	def dom_change_listener.nodeAdded(event)
		puts '[+] DOM node added'
	end
	def dom_change_listener.nodeDeleted(event)
		puts '[+] DOM node deleted'
	end
	return dom_change_listener
end

def prepare_webclient(url)

	# web_client
	#ie6 = BrowserVersion.new("4.0 (compatible; MSIE 6.0b; Windows 98)", "Mozilla/4.0 (compatible; MSIE 6.0; Windows 98)", 6, "IE6")
	web_client = WebClient.new()
	
	web_client.setPopupBlockerEnabled(true);
	#web_client.setCookieManager(new CookieManager());
	
	web_client.setThrowExceptionOnFailingStatusCode(false);

	web_client.setJavaScriptEnabled(true);
	web_client.setThrowExceptionOnScriptError(false);


	# set hooks
	web_client.setIncorrectnessListener(HookedIncorrectnessListener.new())

	#window_listener = prepare_window_listener()
	#web_client.addWebWindowListener(window_listener)

	js_preprocessor = prepare_js_preprocessor()
	web_client.setScriptPreProcessor(js_preprocessor)

	js_debugger = HookedDebuggerImpl.new
	web_client.getJavaScriptEngine().getContextFactory().setDebugger(js_debugger)

	return web_client

end

##############################################################################################
# prepare
##############################################################################################

time_start = Time.now

# prepare client
url_str = "http://localhost/test.html"
#url_str = 'http://www.kurtenba.ch/malware/sinowal/sinowal.html'
url_str = ARGV[0]
begin
	nohtml = ARGV[1]
rescue
	nohtml = '1'
end

url = URL.new(url_str)
host = URI.parse(url_str).host

web_client = prepare_webclient(url)
hooked_connection = HookedWebConnection.new(web_client)
web_request = WebRequestSettings.new(url)
web_request.setAdditionalHeader('Referer', 'http://www.google.com/')


##############################################################################################
# get + process
##############################################################################################

page = web_client.getPage(web_request)

#dom_change_listener = prepare_dom_change_listener()
#page.addDomChangeListener(dom_change_listener)


##############################################################################################
# analyse
##############################################################################################


puts '###############################################'
puts '# DONE PROCESSING'
puts '###############################################'


time_diff = Time.now - time_start


begin
	# javascript elements of page
	js_elements = page.getElementsByTagName("script")
	js_elements.each do |js_element|
		puts "[+] script:\n"  +js_element.asXml()+ "\n"
	end
	puts '[+] got ' +js_elements.length.to_s+ ' script elements'

	# iframe elements of page
	iframe_elements = page.getElementsByTagName("iframe")
	iframe_elements.each do |iframe_element|
		puts "iframe:\n"  +iframe_element.asXml()+ "\n"
	end
rescue
end



# response
response = page.getWebResponse()
raw_content = response.getContentAsString() # received first url
md5 = Digest::MD5.hexdigest(raw_content)

# page xml processed + received all
#page_xml = page.asXml()
#puts '[+] got ' +page_xml.scan(/document.write/).length.to_s+ ' document.write elements'
#puts page_xml

# page processed like in browser
#page_txt = page.getPage().asText()
#puts "[+] processed data:\n" +page_txt

web_window = page.getEnclosingWindow()
js_script_object = web_window.getScriptObject()
js_object_names = js_script_object.getAllIds()

#js_object_names = page.getScriptObject().getAllIds()

puts "[+] nr js_object_Ids " + js_object_names.length.to_s
js_object_values = Array.new
for i in (0..js_object_names.length-1)
#	js_object_values << page.getScriptObject().get(js_object_names[i]) 
	begin
		js_object_values << js_script_object.get(js_object_names[i].to_s) 
#	js_object_values << page.executeJavaScript("print("+js_object_names[i]+")") 
	
#	puts "[+] js_object_Id " + js_object_names[i].to_s+ ' ' +js_object_values[i].to_s
	rescue
#		puts "[+] js_object_Id FAILED"
	end
end



begin
	puts '[+] got ' +iframe_elements.length.to_s+ ' iframe elements'
rescue
end

puts '[+] got ' +$js_exec_count.to_s+ ' javascript executions'
for script in $js_exec_source:
	puts '[+] js eval:' +" \n"+script
end
puts '[+] got ' +$js_exec_max_size.to_s+ ' bytes javascript max size'
puts '[+] got ' +$js_exec_comulated_size.to_s+ ' bytes javascript comulated size'

$js_exec_max_size = 0

list_requests = hooked_connection.getListRequests()
puts '[+] got ' +(list_requests.length).to_s+ ' requests'
for i in (0..(list_requests.length-1))
	puts '	url '+(i+1).to_s+': ' +list_requests[i][1] + ' ' +list_requests[i][0]
end

list_redirects = hooked_connection.getListRedirects()
puts '[+] got ' +(list_redirects.length).to_s+ ' redirects'
for i in (0..(list_redirects.length-1))
	puts '	got redirect for: '+(i+1).to_s+': ' +list_redirects[i][1] + ' ' +list_redirects[i][0]
end
$js_var_size_sum = 0
for i in $js_dom_objects:
	puts '[+] js DOM object: ' +i[0] +' '+i[1]
	$js_var_size_sum += i[1].length
end

for i in $js_global_vars:
	puts '[+] js global vars: ' +i[0]
end

# corejs java loggger
corejs_loggg_uniq = Array.new()
corejs_loggger = CoreJSLoggger.new()
corejs_loggg = corejs_loggger.popp()
for x in (0..corejs_loggg.length):
	if corejs_loggg[x]
		corejs_loggg_uniq << corejs_loggg[x] 
	end
end
corejs_loggg_uniq = corejs_loggg_uniq.uniq
corejs_loggg_uniq.delete_at(0) # [IdFunctionObject:call, Error]
corejs_loggg_uniq.delete_at(0) # [IdFunctionObject:call, Object]

# corejs exception loggger
corejs_exception_loggg_uniq = Array.new()
corejs_exception_loggger = CoreJSExceptionLoggger.new()
corejs_exception_loggg = corejs_exception_loggger.popp()
for x in (0..corejs_exception_loggg.length):
	if corejs_exception_loggg[x]
		corejs_exception_loggg_uniq << corejs_exception_loggg[x] 
	end
end
corejs_exception_loggg_uniq = corejs_exception_loggg_uniq.uniq

# htmlunit java loggger
htmlunit_loggg_uniq = Array.new()
htmlunit_loggger = HtmlunitLoggger.new()
htmlunit_loggg = htmlunit_loggger.popp()
for x in (0..htmlunit_loggg.length):
	if htmlunit_loggg[x]
		htmlunit_loggg_uniq << htmlunit_loggg[x]
	end
end
htmlunit_loggg_uniq = htmlunit_loggg_uniq.uniq 

# activeX loggger
activex_loggg_uniq = Array.new()
activex_loggger = HtmlunitActiveXLoggger.new()
activex_loggg = activex_loggger.popp() 
for x in (0..activex_loggg.length):
	if activex_loggg[x]
		activex_loggg_uniq << activex_loggg[x]
	end
end
activex_loggg_uniq = activex_loggg_uniq.uniq


###########
for x in htmlunit_loggg_uniq:
	puts '[htmlunit_loggger] ' +x.to_s
end

for x in corejs_loggg_uniq:
	puts '[corejs_loggger] ' +x.to_s
end

for x in corejs_exception_loggg_uniq:
	puts '[corejs_exception_loggger] ' +x.to_s
end

for x in activex_loggg_uniq:
	puts '[activeX_logger] ' +x.to_s
end


activex_map = web_client.getActiveXObjectMap()
for x in activex_map:
	puts '[activex_map]' +x.to_s
end

puts "[+] exec time : " +time_diff.to_s+ " sec (js errors: " +$js_exec_errors.length.to_s+ ")"
for x in $js_exec_errors:
	puts x.to_s
end


if nohtml == '0':
	puts '[+] nohtml, exiting'
	exit
end


#################################################################
# HTML generation
#################################################################

puts "[+] generating html.."


html = "
<html>
<head>
<style type='text/css'> .table {border:0px solid #ffffff; background-color:#888888;} </style>
<style type='text/css'> .table td {font-family:serif; font-size:12px;} </style>
<style type='text/css'> .hr {color:white; size:1px; width:800px;} </style>
<style type='text/css'> .code {word-wrap: break-word; word-break: break-all; table-layout:fixed; width:800px; margin:0px; padding:5px} </style>
<style type='text/css'> .dashed {border: 1px dashed #888888; margin:0px; padding:5px;} </style>
<style>#page-wrap { width: 780px; margin: 50px auto; padding: 20px; background: white; -moz-box-shadow: 0 0 20px black; -webkit-box-shadow: 0 0 20px black; box-shadow: 0 0 20px black; }</style>
<script type='text/javascript' src='toolbox/einars-js-beautify/beautify.js'></script>
<script type='text/javascript' src='toolbox/google-code-prettify/prettify.js'></script>
<link href='toolbox/google-code-prettify/prettify.css' type='text/css' rel='stylesheet' />

</head>


<body>
<center>
<table width=800px>
<tr>
<td>
"
html += "<b>Report for: " +list_requests[0][0]+ "</b><br>\n"
html += "<hr class='hr' align=left><br>\n"
html += "<table>\n"
html += "<tr><td> time:</td><td>" +time_start.to_s+ "</td></tr>\n"
html += "<tr><td> runtime:</td><td>" +time_diff.to_s+ " sec.</td></tr>\n"
html += "<tr><td> md5:</td><td>" +md5+ "</td></tr>\n"
html += "<tr><td> js execs:</td><td>" +$js_exec_count.to_s + " (" +$js_exec_errors.length.to_s+ " errors)</td></tr>\n"
html += "<tr><td> js exec size:</td><td>" +$js_exec_comulated_size.to_s+ " bytes</td></tr>\n"
html += "<tr><td> js variables size:</td><td>" +$js_var_size_sum.to_s+ " bytes</td></tr>\n"
html += "</table>\n"



html += "<br><b>Request Chain</b>\n"
html += "<br><table>\n"
for i in (0..(list_requests.length-1))
	html += "<trx><td valign=top>" +(i+1).to_s+ "</td><td valign=top>" +list_requests[i][1]+ "</td><td style='word-wrap: break-word; word-break: break-all; width=600px'>" +list_requests[i][0]+ "</td></tr>\n"
end
html += "</table>\n" 


html += "<br><b>Redirect Chain</b>\n"
html += "<br><table>\n"
for i in (0..(list_redirects.length-1))
	html += "<tr><td>" +(i+1).to_s+ "</td><td>" +list_redirects[i][1]+ "</td><td>" +list_redirects[i][0]+ "</td></tr>\n"
end
html += "</table>\n" 

def htmlentities(src)
#	src = src.gsub('"','&apos;')
#	src = src.gsub("'",'&quot;')
	src = src.gsub('<','&lt;')
	src = src.gsub('>','&gt;')
#	src = src.gsub('&','&amp;')
	return src
end

#open tmpfile in memory to be used

def format_js(script)
	file = Tempfile.new('neox_beautify_js')
	file.puts htmlentities(script)
	file.close
	args = ENV['JSBEAUTY'] || ""
	path = file.path
	command = "rhino beautify-cl.js '#{args} #{path}' 2>&1"
	js_formatted = `#{command}`
	return js_formatted 
end

html += "<br><b>Evals</b> ("+$js_exec_source.length.to_s+")\n"
html += "<br><table class=code>\n"

Dir.chdir 'einars-js-beautify-f614cc4/'

i=1
html += "<tr><td><a name='offset'></a>"
for item in $js_exec_source
	html += i.to_s+" <a href='#offset"+i.to_s+"'>javascript eval "+i.to_s+"</a><br>"
	i+=1
end
html += "<br></td></tr>"

i=1
for script in $js_exec_source:
	html += "<tr><td><a name='offset"+i.to_s+"'></a>javascript eval "+(i).to_s+"</td></tr><tr><td bgcolor=#ededed class=dashed><pre class='prettyprint'>" +format_js(script)+ "</pre></td></tr><tr><td height=8px>(<a href='#offset'>up</a>)<br><br></td></tr>\n"
	i+=1
end
html += "</table>\n" 


html += "<br><b>JS DOM Objects</b>\n"
html += "<br><table class=code>\n"
for js_dom_object in $js_dom_objects:
	html += "<tr><td bgcolor=#ededed class=dashed><pre class='prettyprint'><code><b>" +js_dom_object[0]+ "</b> = " +htmlentities(js_dom_object[1])+ "</code></pre></td></tr><tr><td height=8px></td></tr>\n"
end
html += "</table>\n" 

html += "<br><b>local function calls</b>\n"
html += "<br><table class=code>\n"
for local_call in htmlunit_loggg_uniq:
	html += "<tr><td bgcolor=#ededed class=dashed><pre class='prettyprint'><code>" +htmlentities(local_call.to_s)+ "</code></pre></td></tr><tr><td height=8px></td></tr>\n"
end
html += "</table>\n" 


html += "<br><b>global native calls</b>\n"
html += "<br><table class=code>\n"
for global_call in corejs_loggg_uniq:
	html += "<tr><td bgcolor=#ededed class=dashed><pre class='prettyprint'><code>" +htmlentities(global_call.to_s)+ "</code></pre></td></tr><tr><td height=8px></td></tr>\n"
end
html += "</table>\n" 


Dir.chdir '..'

# END
html += " </td> </tr>
</table>
</center>
<script>prettyPrint()</script>
</body>
</html>
"

# write log
timestamp = time_start.strftime("%Y%m%d%H%M%S")
#logfile = File.new('out/'+timestamp+'_'+host+'_'+md5+'.html', 'w')
logfile = File.new('out/'+timestamp+'_'+host+'.html', 'w')
logfile.write(html)
logfile.close()


puts 'out/'+timestamp+'_'+host+'.html'


#################################################################
# 
#################################################################

