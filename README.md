# Automation of Prosthetic Mesh Generation using Neuralangelo
In underserved communities in Africa, patients lack the financial capacity to afford prosthetic devices. This gets worse for young children who need to replace prostethic devices frequently due to growth. This project in collaboration with the AiPEX (Artificial Intelligence in Products Engineered for X) lab at CMU aims to leverage NVIDIA's Neuralangelo algorithm to reconstruct the residual arm in the form of a 3D mesh. 

---
**Basic Pipeline**

Video &#8594; Images &#8594; Rembg &#8594; Neuralangelo &#8594; Post-processor &#8594; Final Mesh

---

Rembg is a deep learning tool for isolating foreground objects. It is used to isolate the residual arm from the rest of the image. The post-processor is a python script that uses trimesh to select the largest connected component from the mesh (We still need more fine-tuning for this as there are shortcomings due to artefacts from the Neuralangelo training process). 

## Guidelines
To run the process for any image, run the following command:

---
```
bash automate.sh video_name.mp4
```
---

Running the above command should run the entire pipeline above and generate a mesh in the current working directory. Note that this entire process can take a timeframe of about 24 hours.




