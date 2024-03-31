from PIL import Image
import numpy as np
import os


input_folders = ['present_images','absent_images']
output_folders = ['present','absent']

#parameters to crop the axes from images
left = 115
top = 50
right = 792
bottom = 583
# change the new_size paramaters to change the size of the image
def resize_image(original_image, output_path, new_size=(28, 28)):
    resized_image = original_image.resize(new_size)
    resized_image.save(output_path)

for folder in output_folders:
    os.makedirs(folder,exist_ok=True)


for input_folder, output_folder in zip(input_folders, output_folders):
    # Get a list of image files in the input folder
    image_files = [f for f in os.listdir(input_folder) if f.endswith(('.png', '.jpg', '.jpeg'))]

    # Sort the list of image files
    sorted_images = sorted(image_files)

    # Take the first 7000 images, adjust as needed
    selected_images = sorted_images[:7000]


    counter = 1
    # Process each selected image
    for image_file in selected_images:
        
        input_path = os.path.join(input_folder, image_file)
        new_name = output_folder+'_'+str(counter)+'.png'
        output_path = os.path.join(output_folder, new_name)
        image = Image.open(input_path)
        modified_image = image.crop((left,top,right,bottom))
        resize_image(modified_image, output_path)
        counter = counter+1
    print(f"Resized and saved {len(selected_images)} images from {input_folder} to {output_folder}.")