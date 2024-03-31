# example of loading the generator model and generating images
import numpy as np
from numpy import asarray
from numpy.random import randn
from numpy.random import randint
from keras.models import load_model
from matplotlib import pyplot
import os 
import random
from PIL import Image
from datetime import datetime

current_datetime = datetime.now()

# Format the date and time as yyyymmddhhmm
date = current_datetime.strftime('%Y%m%d%H%M')

# generate points in latent space as input for the generator
def generate_latent_points(latent_dim, n_samples, n_classes=2):
 # generate points in the latent space
 x_input = randn(latent_dim * n_samples)
 # reshape into a batch of inputs for the network
 z_input = x_input.reshape(n_samples, latent_dim)
 # generate labels
 labels = randint(0, n_classes, n_samples)
 return [z_input, labels]
 
# create and save a plot of generated images
def save_plot(examples, n):
 # plot images
 for i in range(n * n):
 # define subplot
    pyplot.subplot(n, n, 1 + i)
 # turn off axis
    pyplot.axis('off')
 # plot raw pixel data
    pyplot.imshow(examples[i, :, :, 0])
 pyplot.show()

def save_gen_plot(examples, n, labels, output_dir):
    # Create directories if they don't exist
    for label in set(labels):
        if label == 0:
           label_name = 'absent'
        else:
           label_name = 'present'
        label_dir = os.path.join(output_dir, f'{label_name}_gen')
        os.makedirs(label_dir, exist_ok=True)

    # plot images and save to corresponding directories
    for i, label in enumerate(labels):
        if label == 0:
           label_name = 'absent'
        else:
           label_name = 'present'
        random_number = random.randint(10000, 99999)
        img = examples[i, :, :, 0]
        label_dir = os.path.join(output_dir, f'{label_name}_gen')
        img_path = os.path.join(label_dir, f'{random_number}.png')
        resized_img = Image.fromarray(img).resize((400, 400))
        resized_array = np.array(resized_img)
        # save image
        pyplot.imsave(img_path, resized_array)

    pyplot.show()

output_directory = f'gen_im_upscale_{date}'
# load model
model = load_model('cgan_generator.h5')
#model.summary()
for i in range(50):
    # generate images
    latent_points, labels = generate_latent_points(128, 4)
    #print(latent_points.shape)
    #print(labels)
    # specify labels
    labels = asarray([x for _ in range(2) for x in range(2)])
    # generate images
    X  = model.predict([latent_points, labels])
    #print(X.shape)
    # scale from [-1,1] to [0,1]
    X = (X + 1) / 2.0
    #print(labels)
    # plot the result
    #save_plot(X, 2)
    save_gen_plot(X, 2, labels, output_directory)
