#
# TODO:
# http://wepawet.iseclab.org/view.php?hash=a38333fe0d36f263fb0f4a85794507c1&t=1253872197&type=js
#
# - html out
# - shellcode search
# - plugin/activeXobjects
#
# page.getWebResponse().getContentAsString() actually returns the content 'as
# > is' returned from the server.
# >
# > You need to use page.asXml() to get the current DOM (which includes
# > JavaScript modifications).
#
#
# webClient.getJavaScriptEngine().getContextFactory().setDebugger(x)
# result = page.executeJavaScript()
# htmlPage.executeJavaScript("return variable_name");
# htmlPage.executeJavaScript("variable_name=" + value); 
#
# If you get an instance of WebWindow (which can be obtained from the WebClient or the Page), calling getScriptObject() will return an instance of Window, which is a Scriptable that acts as the global scope for that browser window.  If you implement your own Debugger, you can intercept all function calls (including top-level scripts) and get access to the code (by implementing Debugger.handleCompilationDone) and the local variables (via the "activation" parameter of DebugFrame.onEnter).  You'll have to be somewhat clever in mapping the compiled code to the DebuggableScript objects (I suggest maintaining a Map<DebuggableScript, String> in your Debugger).  Unfortunately, Rhino doesn't include this API in the Javadoc that they publish on their website, so you'll need to poke around in the Rhino source files to see the documentation.
#
# http://www.mozilla.org/rhino/rhino15R4-debugger.html
# frame1 = cx.getDebuggableEngine().getFrame(0)
#
# There is a Proxy sub-project which could be used to log all JavaScript 
# function invocations. It is not very mature, but it passed GWT examples at the moment.
# https://htmlunit.svn.sourceforge.net/svnroot/htmlunit/trunk/proxy
#
#
# ??? functionOrScript parameters != args ?
#
# webClient.setWebConnection(new DebuggingWebConnection(webClient.getWebConnection(), "some_folder_name"));
#
#
# webClient = lient.setRefreshHandler(new RefreshHandler() {
#   public void handleRefresh(Page page, URL url, int arg) throws IOException {
#     System.out.println("handleRefresh");
#   }
# });
#
# http://www.pluitsolutions.com/2006/10/05/overriding-methods-in-ruby/
#
# webClient.setPopupBlockerEnabled(true);
# webClient.setCookieManager(new CookieManager());
# webClient.setThrowExceptionOnFailingStatusCode(false);
# webClient.setThrowExceptionOnScriptError(false);
# webClient.setJavaScriptEnabled(true);
#
#
# environment:
#
# run:
# - simplelog.properties + commons-loggin.properties in root path (project_x.rb)
# - CLASSPATH=
#
# compile loggger.jar
# javac loggger/Loggger.class
# jar cf loggger.jar loggger/Loggger.class
#  java: 
#  jruby: include_class 'loggger.Loggger'
# 
# compile core-js:
# - export JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.20/
# - export CLASSPATH=lib/:lib/commons-logging-1.1.1.jar:lib/loggger.jar:.
# - build.xml add:
#   <property name="commons-logging.jar" location="lib/commons-logging-1.1.1.jar" />
#
# use:
# import loggger.*;
#
#

require 'java'



require 'apache-mime4j-0.6.jar'
require 'commons-codec-1.4.jar'
require 'commons-collections-3.2.1.jar'
require 'commons-io-1.4.jar'
require 'commons-lang-2.4.jar'
require 'commons-logging-1.1.1.jar'
require 'cssparser-0.9.5.jar'
require 'htmlunit-2.8.jar'
require 'htmlunit-core-js-2.8.jar'
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


