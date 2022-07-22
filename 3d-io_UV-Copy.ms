-- Copyright 2022 3d-io
-- 3D-IO Games & Video Production GmbH | Albrechtstrasse 46 | 65185 Wiesbaden | GERMANY
-- Contact: info@3d-plugin.com
-- Homepage: www.3d-plugin.com
-- Version 1.1



macroScript UVCopy
	category:"3d-io"
	toolTip:"UV-Copy"
	icon:#("UV-Copy", 1)
(

	fn switchCannelsDefault map source target = (
		-- coords.mapChannel is used by all general maps that support 'coordinates'
		if (map != undefined and
			hasProperty map "coords" and
			hasProperty map.coords "mapChannel" and
			map.coords.mapChannel == source)
		do (
			map.coords.mapChannel = target
		)
	)


	fn switchCannelsInImage map source target = (
		-- special handling for ai_image (Arnold Image)
		-- ai_image starts counting at 0!
		if (map != undefined and
			hasProperty map "uvset" and
			map.uvset == source - 1)
		do (
			map.uvset = target - 1
		)
	)


	fn switchCannelsInOslMap map source target = (
		-- special handling for OSLMap
		if (map != undefined and
			hasProperty map "UVSet" and
			map.UVSet == source)
		do (
			map.UVSet = target
		)
	)


	fn switchChannelsInMap map source target = (
		if (map != undefined) do (
			numSumMaps = getNumSubTexmaps map
			for i = 1 to numSumMaps do (
				subMap = getSubTexmap map i
				switchChannelsInMap subMap source target
			)
			if (classOf(map) == ai_image) then (
				switchCannelsInImage map source target
			) else (
				if (classOf(map) == OSLMap) then (
					switchCannelsInOslMap map source target
				) else (
					switchCannelsDefault map source target
				)
			)
		)
	)


	fn switchChannelsInMat mat source target = (
		if (mat != undefined) do (
			numSubMtls = getNumSubMtls mat
			for i = 1 to numSubMtls do (
				subMat = getSubMtl mat i
				switchChannelsInMat subMat source target
			)
	
			numSumMaps = getNumSubTexmaps mat
			for i = 1 to numSumMaps do (
				subMap = getSubTexmap mat i
				switchChannelsInMap subMap source target
			)
		)
	)


	fn switchTextureChannels switchObjects sourceChannel targetChannel = (
		if (switchObjects != undefined) do (
			for item in switchObjects do (
				if (item.material != undefined) do (
					switchChannelsInMat item.material sourceChannel targetChannel
				)
			)
		)
	)


	fn switchObjectUV switchObjects sourceChannel targetChannel = (
		if (switchObjects != undefined) do (
			for item in switchObjects do (
				channelinfo.copychannel item 3 sourceChannel
				channelinfo.pastechannel item 3 targetChannel
			)
		)
	)


	fn SwitchMapChannels sourceChannel targetChannel = (
		switchObjects = $
		switchObjectUV switchObjects sourceChannel targetChannel
		switchTextureChannels switchObjects sourceChannel targetChannel
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