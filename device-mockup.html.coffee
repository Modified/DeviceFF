### device-mockup.html.coffee
Device mockup teacup template.
###
{renderable,normalizeArgs,comment,doctype,html,head,title,link,meta,script,body,section,div,span,em,strong,i,b,p,q,nav,header,footer,h1,h2,h3,a,img,form,input,label,button,select,option,fieldset,ol,ul,li,table,tr,th,td,text,raw,tag,iframe,br,coffeescript}=require 'teacup'

module.exports=renderable (params)->
	doctype 5
	html ->
		head -> #??? (Some practice dropping head and body since browsers tolerate it.)
			meta charset:'utf-8'
			meta name:'viewport',content:'width=device-width,initial-scale=1,maximum-scale=1' #??? Which?
			title 'Device mockup frame'
			link rel:'stylesheet',href:'device-mockup.css' #??? Inline everything!
		body ->
			#??? h1 'Device Mockups'
			div '.device',->
				nav ->
					label '⚒'
					form ->
						select -> #??? Replace with widget like Chosen, if want to bother with custom sizes?
							option 'iPad (768x1024)' # Regexp looks for "(_x_)".
							option selected:yes,'iPhone 4 (320x480)'
							option 'iPhone 5 (320x568)'
							option 'iPhone 6 (375x667)'
							option 'iPhone 6 Plus (414x736)'
							option 'Nexus 4 (384x640)'
							option 'Nexus 5 (360x640)'
							option 'Nexus 7 (600x960)'
							option 'Nexus 10 (800x1280)'
						button type:'button','Landscape' #??? Meh; do it right: radios, or group of buttons widget.
						input type:'text',placeholder:'URL',name:'URL'
						###???
						label ->
							text 'URL'
						###

				div '.screen',-> # Divitis? Yeah, but.
					iframe src:'index.html',border:'0',frameborder:'0',scrolling:'0',marginwidth:'0',marginheight:'0' #??? Defaults?

			# Scripts.
			script src:'//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'
			coffeescript -> #??? CS adds some ugly unused boilerplate, so just use script and JS?
				# Fallback to self-hosted if CDN…? Works around scheme-less URLs.
				window.jQuery or document.write '<script src="lib/jquery-2.1.3.min.js">\x3c/script>'

			# Handle form.
			coffeescript ->
				$ ->
					form=$ 'form'
					.on 'submit',(ev)->ev.preventDefault()

					# Dropdown/up.
					$ 'nav>label'
					.on 'click',->
						form.toggle()

					# Device select.
					size=$ 'select'
					.on 'change',->
						# Extract dimensions from device description.
						t=$ 'option:selected'
						.text()
						dim=/\((\d+)x(\d+)\)/.exec t
						# Orientation?
						o=orient.text() isnt 'Portrait'
						# Resize.
						$ '.device'
						.width dim[if o then 1 else 2] # Flip dimensions for landscape.
						.height dim[if o then 2 else 1]
						form.hide()

					# Portrait/landscape toggle.
					orient=$ 'button'
					.on 'click',->
						if orient.text() is 'Portrait' then orient.text 'Landscape'
						else orient.text 'Portrait'
						size.trigger 'change'
						form.hide()

					#??? Drag to resize iframe?

					# Edit URL.
					url=$ '[name="URL"]'
					.on 'change',-> #??? Throttled input instead?
						$ 'iframe'
						.attr src:url.val()
						form.hide()

					# Init.
					size.trigger 'change'
