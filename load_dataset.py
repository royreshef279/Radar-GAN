import os
from PIL import Image
import numpy as np
from sklearn.model_selection import train_test_split
from matplotlib import pyplot

def load_data(data_folder, test_size=0.2, random_state=42):
    images = []
    labels = []

    label_mapping = {'absent': 0, 'present': 1}  # Map labels to integers

    for filename in os.listdir(data_folder):
        if filename.endswith(('.png', '.jpg', '.jpeg')):
            # Load the image
            img = Image.open(os.path.join(data_folder, filename)).convert('L')  # Convert to grayscale
            img = img.resize((28, 28))  # Resize as needed
            img_array = np.array(img)[:, :, np.newaxis]  # Add a third dimension for channels

            # Extract label from the filename
            label = filename.split('_')[0]

            # Map labels to numeric values (0 for 'absent', 1 for 'present')
            numeric_label = label_mapping[label]

            images.append(img_array)
            labels.append(numeric_label)

    x_data = np.array(images)
    y_data = np.array(labels)

    # Split the data into training and testing sets
    x_train, x_test, y_train, y_test = train_test_split(x_data, y_data, test_size=test_size, random_state=random_state)
    x_train = np.squeeze(x_train)
    x_test = np.squeeze(x_test)

    return (x_train, y_train), (x_test, y_test)

# Example usage
#data_folder_combined = 'dataset_images'
#(x_train_combined, y_train_combined), (x_test, y_test) = load_data(data_folder_combined)

#print(x_test.shape)

#for i in range(100):
 # define subplot
 #pyplot.subplot(10, 10, 1 + i)
 # turn off axis
 #pyplot.axis('off')
 # plot raw pixel data
 #pyplot.imshow(x_train_combined[i], cmap='gray_r')
#pyplot.show()