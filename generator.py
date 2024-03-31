from keras.layers import Input, Dense, Reshape, Embedding, Concatenate
from keras.layers import Conv2DTranspose, Conv2D, LeakyReLU
from keras.models import Model

def define_generator(latent_dim, n_classes=2):
    # label input
    in_label = Input(shape=(1,))
    # embedding for categorical input
    li = Embedding(n_classes, 50)(in_label)
    # linear multiplication
    n_nodes = 7 * 7
    li = Dense(n_nodes)(li)
    # reshape to additional channel
    li = Reshape((7, 7, 1))(li)
    
    # image generator input
    in_lat = Input(shape=(latent_dim,))
    # foundation for 7x7 image
    n_nodes = 128 * 7 * 7
    gen = Dense(n_nodes)(in_lat)
    gen = LeakyReLU(alpha=0.2)(gen)
    gen = Reshape((7, 7, 128))(gen)
    
    # merge image gen and label input
    merge = Concatenate()([gen, li])
    
    # upsample to 14x14
    gen = Conv2DTranspose(128, (4,4), strides=(2,2), padding='same')(merge)
    gen = LeakyReLU(alpha=0.2)(gen)
    
    # upsample to 28x28
    gen = Conv2DTranspose(128, (4,4), strides=(2,2), padding='same')(gen)
    gen = LeakyReLU(alpha=0.2)(gen)
    
    # output
    out_layer = Conv2D(3, (7,7), activation='tanh', padding='same')(gen)  # Change to 3 channels
    
    # define model
    model = Model([in_lat, in_label], out_layer)
    return model

# Example usage
latent_dim = 128
generator = define_generator(latent_dim)
generator.summary()
