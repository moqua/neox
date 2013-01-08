

require 'java'

require 'build/2.8/htmlunit-2.8/target/htmlunit-2.9-SNAPSHOT.jar'
require 'build/2.8/core-js/target/htmlunit-core-js-2.8.jar'
require 'build/loggger/loggger.jar'


require 'apache-mime4j-0.6.jar'
require 'commons-codec-1.4.jar'
require 'commons-collections-3.2.1.jar'
require 'commons-io-1.4.jar'
require 'commons-lang-2.4.jar'
require 'commons-logging-1.1.1.jar'
require 'cssparser-0.9.5.jar'
#require 'htmlunit-2.8.jar'
#require 'htmlunit-core-js-2.8.jar'
require 'httpclient-4.0.1.jar'
require 'httpcore-4.0.1.jar'
require 'httpmime-4.0.1.jar'
require 'nekohtml-1.9.14.jar'
require 'sac-1.3.jar'
require 'serializer-2.7.1.jar'
require 'xalan-2.7.1.jar'
require 'xercesImpl-2.9.1.jar'
require 'xml-apis-1.3.04.jar'


include_class 'java.net.URL'
include_class 'com.gargoylesoftware.htmlunit.WebClient'
include_class 'com.gargoylesoftware.htmlunit.WebWindow'
include_class 'com.gargoylesoftware.htmlunit.WebWindowListener'
include_class 'com.gargoylesoftware.htmlunit.WebRequestSettings'
include_class 'com.gargoylesoftware.htmlunit.BrowserVersion'
include_class 'com.gargoylesoftware.htmlunit.HttpWebConnection'
include_class 'com.gargoylesoftware.htmlunit.IncorrectnessListenerImpl'

include_class 'com.gargoylesoftware.htmlunit.util.WebConnectionWrapper'

include_class 'com.gargoylesoftware.htmlunit.html.DomNode'
include_class 'com.gargoylesoftware.htmlunit.html.DomChangeListener'

include_class 'com.gargoylesoftware.htmlunit.javascript.JavaScriptEngine'
include_class 'com.gargoylesoftware.htmlunit.ScriptPreProcessor'
include_class 'com.gargoylesoftware.htmlunit.javascript.DebuggerImpl'
#include_class 'net.sourceforge.htmlunit.corejs.javascript.debug.DebugFrame'
include_class 'com.gargoylesoftware.htmlunit.javascript.DebugFrameImpl'
#include_class 'com.gargoylesoftware.htmlunit.javascript.DebugFrameAdapter'
#

# prepare client
#url_str = "http://localhost/test.html"
url_str = 'http://www.kurtenba.ch/malware/sinowal/sinowal.html'
#url_str = 'http://traffic-source.org/voli9x1.php?s=1e2f95e99bf41e39c28ff5b04f7e55bf'
url_str = ARGV[0]
url = URL.new(url_str)

# web_request
web_request = WebRequestSettings.new(url)
web_request.setAdditionalHeader('Referer', 'http://www.google.com/')

# web_client
#browser_ver = BrowserVersion.new( 'Netscape', 'Mozilla/5.0', 'Mozilla/5.0 (X11; U; Linux i686; en-US)', 5.0 )
web_client = WebClient.new()

# get + process page
page = web_client.getPage(web_request)

# response
response = page.getWebResponse()
#puts response.getContentAsString() # received first url

# page xml processed + received all
#page_xml = page.asXml()
#puts '[+] got ' +page_xml.scan(/document.write/).length.to_s+ ' document.write elements'
#puts page_xml

# page processed like in browser
#page_txt = page.getPage().asText()
#puts "[+] processed data:\n" +page_txt


