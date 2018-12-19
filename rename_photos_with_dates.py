# Python3 script to rename photos using their Exif dates.
# note: must install 'arrow' using 'pip3 install arrow'
# note: must install 'exifread' using 'pip3 install exifread'

import os, arrow, pyexifinfo

def main():
    
    for name in os.listdir("."):
        if os.path.isdir(name):
            print("ignoring",name,"because it's a directory")
            continue
        else:
            lower_name=name.lower()
            if not lower_name.endswith(('.jpg','.png','.gif','.bmp','.tif','.heic','.xmp','.mov','.mp4','.jpeg','.aifc', '.pdf', '.m4v', '.ico','.m4a')):
                print("ignoring \""+name+"\" because it's not a recognized image or video format")
                continue
        try:
            info=pyexifinfo.get_json(name)[0]
            possible_keys=['EXIF:DateTimeOriginal','XMP:DateCreated','QuickTime:CreationDate','File:FileModifyDate']
            modified_key_only=False
            key='key not found'
            for try_key in possible_keys:
                if try_key in info:
                    key=try_key
                    if key==possible_keys[-1]:
                        print("WARNING:",name,"only has file *modified* key, so may be incorrect date")
                        modified_key_only=True
                    break
            
            if key=='key not found':
                print(name,"has no known DateCreated key")
                continue
            
            date=str(info[key])
            arr=arrow.get(date,['YYYY:MM:DD HH:mm:ssZZ','YYYY:MM:DD HH:mm:ss'])
        except arrow.parser.ParserError:
            print("Ignoring",name,"since it contains no key with viable creation date.")
        else:
            # NOTE: I actually prefer just having names using local time. For example, the local EST
            #       might be 12:28:12, EST is -04:00, so the utc time is 16:28:12. To me it's more
            #       intuitive to just use the local time like all the other files use by default.
            #newNameStart=arr.to('utc').format('YYYY:MM:DD_HH:mm:ss-')
            newNameStart=arr.format('YYYY.MM.DD_HH.mm.ss-')
            if modified_key_only:
                newNameStart="last_modified-"+newNameStart
            if not name.startswith(newNameStart):
                newName=newNameStart+name
                print("renaming",name,"to",newName)
                #os.rename(name,newName)
            else:
                print("ignoring",name,"since it already seems to be correctly prefixed with creation date")

# Driver Code
if __name__ == '__main__':
    main()
