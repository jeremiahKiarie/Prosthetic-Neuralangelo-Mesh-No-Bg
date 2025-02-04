# Automation of Prosthetic Mesh Generation using Neuralangelo
This work represents the 3D prosthetic mesh generation for the [2025 ASME Journal Paper on Accessible Digital Reconstruction and Mechanical Prediction of 3D-Printed Prosthetics](https://asmedigitalcollection.asme.org/mechanicaldesign/article/doi/10.1115/1.4067716/1212255). It was done in collaboration with the [AiPEX (Artificial Intelligence in Products Engineered for X) lab at Carnegie Mellon University](https://www.meche.engineering.cmu.edu/faculty/aipex.html) and leverages NVIDIA's Neuralangelo algorithm to reconstruct a residual body part in the form of a 3D mesh.

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

Running the above command should run the entire pipeline above and generate a mesh in the current working directory. Note that this entire process can take a timeframe of about 24 hours.<br>

In the scenario that you are doing anything via ssh, it is best to be able to run the above command with nohup in case your connection times out. To do that, do the following:

---
```
nohup bash automate.sh video_name.mp4 > logfile.log 2>&1 &
```
---

If you have a connection reset and you login to the remote workstation, to see the state of your training, run:

---
```
tail -f -n 1 /path/to/your/logfile.log
```
---




