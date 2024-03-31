# Radar-GAN
Adversiaral Radar -  GAN for generating radar images of absent or present targets

This is based on the research done in: https://cradpdf.drdc-rddc.gc.ca/PDFS/unc375/p813859_A1b.pdf
and the GAN from https://machinelearningmastery.com/how-to-develop-a-conditional-generative-adversarial-network-from-scratch/

To test the GAN follow these instructions:

1. Run the *dataset.m* file to generate the dataset. This will store the data in a struct format (this might a while, since it's generating 96000 waveforms).
2. Run the *image_gen.m* to generate the image based on ambiguity function from the waveform struct. This will create two separate folders for 'absent' and 'present' target labels.
3. Run the *image_resize.py* file to resize the images and remove the axes from the MATLAB saved images. You can adjust the size of the saved images and the number of images to to save as needed.
4. Run the *cgan.py* file to the train and generate the model. 
5. Run the *generate_images.py* to the test the model and generate images from the two labels.
