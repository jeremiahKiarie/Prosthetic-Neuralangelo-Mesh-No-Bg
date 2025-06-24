# Automation of Prosthetic Mesh Generation using Neuralangelo
In underserved communities in Africa, patients lack the financial capacity to afford prosthetic devices. This gets worse for young children who need to replace prostethic devices frequently due to growth. This project in collaboration with the AiPEX (Artificial Intelligence in Products Engineered for X) lab at CMU aims to leverage NVIDIA's Neuralangelo algorithm to reconstruct the residual arm in the form of a 3D mesh. 

---
**Basic Pipeline**

Video &#8594; Images &#8594; Rembg &#8594; Neuralangelo &#8594; Post-processor &#8594; Final Mesh

---

Rembg is a deep learning tool for isolating foreground objects. It is used to isolate the residual arm from the rest of the image. The post-processor is a python script that uses trimesh to select the largest connected component from the mesh (We still need more fine-tuning for this as there are shortcomings due to artefacts from the Neuralangelo training process). 

> [!Tip]  
> For Installation and running locally in Anaconda enviroinment, check out the [local installation guide](https://github.com/pere49/3d-reconstruction-neuralangelo-local?tab=readme-ov-file)

## Prerequisites
+ [Nvidia drivers](https://docs.docker.com/engine/install/)
+ [Docker](https://www.nvidia.com/en-us/drivers/)

or after cloning the repository you can run the scripts(Ubuntu only):
1. Installing nvidia drivers:
```
sudo bash setup_nvidia_drivers.sh
```
---
2. Docker installation:
```
sudo bash setup_docker.sh
```
---
> [!WARNING]  
> Scripts may fail, and if unable to debug, refer to official documentation

## Guidelines
### Running individual pipelines
The above script allows running the pipeline in two individual pipelines independently i.e. colmap pipeline and neuralangelo pipeline.
To run the Colmap pipeline:

```
nohup bash automate_colmap.sh video_name.mp4 > colmap_file.log 2>&1 &
```

To run the neuralangelo pipeline: 

```
nohup bash automate_neuralangelo.sh video_name.mp4 > neuralangelo_file.log 2>&1 &
```

### Running whole pipeline
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

You can also run the colmap and neuralangelo containers separately, also start the reconstruction from neuralangelo. For colmap:

---
```
nohup bash automate_colmap.sh video_name.mp4 > logfile.log 2>&1 &
```
---
and for neuralangelo:
---
```
nohup bash automate.sh video_name.mp4 > logfile.log 2>&1 &
```
---



