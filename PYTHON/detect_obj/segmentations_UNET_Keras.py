import numpy as np
import PIL.Image as image
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

def loadData(filePath):
    f = open(filePath,'rb')
    data = []
    img = image.open(f)
    m,n = img.size
    for i in range(m):
        for j in range(n):
            x,y,z = img.getpixel((i,j))
            data.append([x/256.0,y/256.0,z/256.0])
    f.close()
    return np.mat(data),m,n

imgData,row,col = loadData('photo160.png')

label = KMeans(n_clusters=2).fit_predict(imgData)

label = label.reshape([row,col])
pic_new = image.new("L", (row, col))

for i in range(row):
    for j in range(col):
        pic_new.putpixel((i,j), int(256/(label[i][j]+1)))




plt.imshow(pic_new)
plt.show()