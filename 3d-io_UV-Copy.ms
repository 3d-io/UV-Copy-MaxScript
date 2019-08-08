-- Copyright 2012 3d-io
-- 3D-IO Games & Video Production GmbH | Albrechtstrasse 46 | 65185 Wiesbaden | GERMANY
-- Contact: info@3d-plugin.com
-- Homepage: www.3d-plugin.com
-- Version 1.0



macroScript UVCopy
	category:"3d-io"
	toolTip:"UV-Copy"
	icon:#("UV-Copy", 1)
(

	fn switchTextureChannels sourceChannel targetChannel = (
		if ($ != undefined) do (
			for item in $ do (
				if (item.material != undefined and hasProperty item.material "maps") do (
					for map in item.material.maps do (
						if (map != undefined and
							hasProperty map "coords" and
							hasProperty map.coords "mapChannel" and
							map.coords.mapChannel == sourceChannel) 
						do (
							map.coords.mapChannel = targetChannel
						)
					)
				)	
			)
		)
	)


	fn switchObjectUV sourceChannel targetChannel = (
		if ($ != undefined) do (
			for item in $ do (
				channelinfo.copychannel item 3 sourceChannel
				channelinfo.pastechannel item 3 targetChannel
			)
		)
	)


	fn SwitchMapChannels sourceChannel targetChannel = (
		switchTextureChannels sourceChannel targetChannel
		switchObjectUV sourceChannel targetChannel
	)


	rollout mapRollout "Map Channel Switcher" (
		spinner sourceChannel "Copy from channel" range:[1, 99, 1] type:#integer fieldwidth:40
		spinner targetChannel "To map channel" range:[1, 99, 1] type:#integer fieldwidth:40
		button switchChannels "Copy"
		label aboutLabel "www.3d-plugin.com"
		on switchChannels pressed do switchMapChannels sourceChannel.value targetChannel.value
	)


	createDialog mapRollout 180 100
)

