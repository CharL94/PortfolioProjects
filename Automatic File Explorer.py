#!/usr/bin/env python
# coding: utf-8

# In[19]:


import os, shutil


# In[24]:


path = r"D:/Downloads/File_Sorter_Test/"


# In[21]:


file_name = os.listdir(path)


# In[23]:


folder_names = ['xlsx files', 'png files', 'text files']

for loop in range(0,3):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs((path + folder_names[loop]))
for file in file_name:
    if ".xlsx" in file and not os.path.exists(path + "xlsx files/" + file):
        shutil.move(path + file, path + "xlsx files/" + file)
    elif ".png" in file and not os.path.exists(path + "png files/" + file):
        shutil.move(path + file, path + "png files/" + file)
    elif ".txt" in file and not os.path.exists(path + "text files/" + file):
        shutil.move(path + file, path + "text files/" + file)    


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




