#!/usr/bin/env python
import urllib.request
import json

# Youtube channel lister: 
# Given a youtube channel or channel(s), print out a list of
# all videos uploaded.  Includes youtube key and video title.

key = "YOUR_YOUTUBE_API_v3_BROWSER_KEY"

#List of channels to search : mention if you are pasting channel id or username - "id" or "forUsername"
#ytids = [["bbcnews","forUsername"],["UCjq4pjKj9X4W9i7UnYShpVg","id"]] # Example of specifying channels by username and channel id
#ytids = [["UCpn6aFvwAI_hK9WuHcdvQGA","id"]] # Vegan Cyclist - used for testing
ytids = [["cubex55","forUsername"]] # World of Longplays

newstitles = []
for ytid,ytparam in ytids:
    urld = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&"+ytparam+"="+ytid+"&key="+key
    with urllib.request.urlopen(urld) as url:
        datad = json.loads(url.read())
    uploadsdet = datad['items']
    #get upload id from channel id
    uploadid = uploadsdet[0]['contentDetails']['relatedPlaylists']['uploads']

    #retrieve list
    first_url = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails&maxResults=50&playlistId="+uploadid+"&key="+key
    urld = first_url

    while True:
        with urllib.request.urlopen(urld) as url:
            datad = json.loads(url.read())

        for data in datad['items']:
            ntitle =  data['snippet']['title']
            nlink = data['contentDetails']['videoId']
            newstitles.append([nlink,ntitle])

        try:
            next_page_token = datad['nextPageToken']
            urld = first_url + '&pageToken={}'.format(next_page_token)
        except:
            break

for link,title in newstitles:
    print(link, title)
