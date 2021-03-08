# Scrolling event calendar for VRCSDK3 Udon
version 1.0.4

Created and operated by Aoi Kamishiro ([@aoi3192][01])  
Illustration and design: Posaka Ere ([@posaca_ere][02])  

## Overview
This is an asset to display [VRChat Event Calendar][11] in VRChat. Many events can be displayed by implementing a scroll bar. Also, by implementing the reload button, the latest calendar can be loaded at any time.  
[Sample World][12]  

## Download
Please download the latest version from the [Release][21] page.  

## How to install
1. Please import the latest versions of VRCSDK3 and UdonSharp beforehand.
2. If you don't have EventSystem in your scene, please create UI/Canvas to generate it. 
3. Place your favorite prefabs in 00Kamishiro/ScrollEventCalender/Prefabs in your scene.  

### Differences between the prefabs
* ScrollEventCalendarUI - This is a calendar that consists only of a UI.  
* ScrollEventCalendarUnlit - A calendar that is not affected by light sources.  
* ScrollEventCalendarStd - A calendar that is affected by light sources.  
* SyncScrollEventCalendarUI - Calendar that consists of UI only. Sliders are synchronized.  
* SyncScrollEventCalendarUnlit - a calendar that is not affected by light sources. The slider will be synchronized.  
* SyncScrollEventCalendarStd - calendar that is affected by light sources. Sliders are synchronized.  

### Brightness control for Std systems
1. adjusts the Emission color of the material assigned to the MeshRenderer component of the "Mesh" object in the prefab. 2.  
2. Adjusts the color of the Image component of the "Scrollbar" and "Handle" objects in the prefab.  

## Terms of Use
* The assets in the UnityPackage are distributed under [MIT License][61].  
* The images distributed by the source URL of the calendar images may not be used for any purpose other than "display in the VRChat world".  
* If you modify or redistribute this asset, please change the image source URL in advance.  

## Credits
This asset was created with reference to the following assets.
* [VRChat Event Calendar][71] : [@kohack_v][72].  
* [vrchat-scroll-calendar][73] : [@bd_j][74].  
  
Event information in the calendar is based on [VRChat Event Calendar][76] by Cuckoo ([@nest_cuckoo_][75]).  
  
The design, color scheme, and header image were done by Posaca Ere ([@posaca_ere][77]).  

### Contact.
[Kamishiro Industries Discrod Server][81] [Twitter: @aoi3  
[Twitter: @aoi3192][82]  
[VRChat: Aoi Kamishiro][83]  

## Related sites.
[Booth: Kamishiro Industries][91]  
[Vket: Kamishiro Industries][92]  
[Github: Aoi Kamishiro][93]  

[01]:https://twitter.com/aoi3192
[02]:https://twitter.com/posaca_ere
[11]:https://sites.google.com/view/vrchat-event
[12]:https://vrchat.com/home/world/wrld_7540f98a-df30-477f-8af3-2868ffec0863
[21]:https://github.com/AoiKamishiro/VRChatUdon_ScrollEventCalendar/releases
[61]:LICENSE-MIT.txt
[71]:https://booth.pm/ja/items/1223535
[72]:https://twitter.com/kohack_v
[73]:https://github.com/bdunderscore/vrchat-scroll-calendar
[74]:https://twitter.com/bd_j
[75]:https://twitter.com/nest_cuckoo_
[76]:https://sites.google.com/view/vrchat-event
[77]:https://twitter.com/posaca_ere
[81]:https://discord.gg/NG3DxyYkCf
[82]:https://twitter.com/aoi3192
[83]:https://www.vrchat.com/home/user/usr_19514816-2cf8-43cc-a046-9e2d87d15af7
[91]:https://kamishirolab.booth.pm/
[92]:https://www.v-market.work/ec/shops/1810/detail/
[93]:https://github.com/AoiKamishiro
