#Creating GPT partition table
sudo parted "${1}" --script -- mklabel gpt
#Creating Ext4 partition using all available space
sudo parted "${1}" --script -- mkpart primary ext4 0% 100%
#Formatting partition 1 as Ext4
sudo mkfs.ext4 -F "${1}1"
sudo parted "${1}" --script print
lsblk | grep "${1}"
