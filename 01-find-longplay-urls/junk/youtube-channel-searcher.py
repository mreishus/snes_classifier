#!/usr/bin/env python
import urllib
import urllib.request
import json

# Searches youtube for channel id + query and prints all results.
# This ended up not working because it's too expensive re: youtube api limits.
# Each call to search costs 100 units and they only give you 10,000 units daily. (WTF?).
# Just testing enough to get the script working exhausted my daily limit quickly.

def get_all_video_in_channel(channel_id, query):
    api_key = "YOUR_YOUTUBE_API_v3_BROWSER_KEY"

    base_video_url = 'https://www.youtube.com/watch?v='
    base_search_url = 'https://www.googleapis.com/youtube/v3/search?'

    first_url = base_search_url+'key={}&channelId={}&q={}&part=snippet,id&order=date&maxResults=25'.format(api_key, channel_id, query)

    video_links = []
    url = first_url
    while True:
        inp = urllib.request.urlopen(url)
        resp = json.load(inp)

        for i in resp['items']:
            if i['id']['kind'] == "youtube#video":
                #{'kind': 'youtube#searchResult', 'etag': '"XpPGQXPnxQJhLgs6enD_n8JR4Qk/FJfQtflXT7PLR81Pxin1fYGsyt0"', 'id': {'kind': 'youtube#video', 'videoId': 'dGmi0FlMErs'}, 'snippet': {'publishedAt': '2015-01-27T20:17:40.000Z', 'channelId': 'UCpn6aFvwAI_hK9WuHcdvQGA', 'title': 'Should kids be vegan? (my vegan parent story)', 'description': 'So I know this is SUPER controversial , but this my story about parenting as vegan. I am not really happy with the things I said in the video, as I cant stress ...', 'thumbnails': {'default': {'url': 'https://i.ytimg.com/vi/dGmi0FlMErs/default.jpg', 'width': 120, 'height': 90}, 'medium': {'url': 'https://i.ytimg.com/vi/dGmi0FlMErs/mqdefault.jpg', 'width': 320, 'height': 180}, 'high': {'url': 'https://i.ytimg.com/vi/dGmi0FlMErs/hqdefault.jpg', 'width': 480, 'height': 360}}, 'channelTitle': 'The Vegan Cyclist', 'liveBroadcastContent': 'none'}} 
                ntitle = i['snippet']['title']
                nlink  = base_video_url + i['id']['videoId']
                video_links.append([nlink,ntitle])

        try:
            next_page_token = resp['nextPageToken']
            url = first_url + '&pageToken={}'.format(next_page_token)
        except:
            break
    return video_links


cid = "UCpn6aFvwAI_hK9WuHcdvQGA"
video_list = get_all_video_in_channel(cid, 'power')
print(video_list)

with open('video_list.json', 'w') as outfile:
    json.dump(video_list, outfile)
