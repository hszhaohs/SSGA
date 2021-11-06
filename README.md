# SSGA
The code of paper [Spectral-Spatial Genetic Algorithm-Based Unsupervised Band Selection for Hyperspectral Image Classification](https://ieeexplore.ieee.org/document/9321482)
```
@ARTICLE{9321482,
  author={Zhao, Haishi and Bruzzone, Lorenzo and Guan, Renchu and Zhou, Fengfeng and Yang, Chen},  
  journal={IEEE Transactions on Geoscience and Remote Sensing},   
  title={Spectral-Spatial Genetic Algorithm-Based Unsupervised Band Selection for Hyperspectral Image Classification},   
  year={2021},  
  volume={59},  
  number={11},  
  pages={9616-9632},  
  doi={10.1109/TGRS.2020.3047223}，
}
```


## Usage

For example, if you want to perform SSGA:

1. Prepare data and put it under `./data`
2. Modify the parameters in `main_ssga_hsi.m` as you need
3. Run `main_ssga_hsi.m`


## References

[1] The code of superpixel segmentation (i.e., the filefolder of `./EntropyRateSuperpixel-master`) is cloned from https://github.com/mingyuliutw/EntropyRateSuperpixel

[2] The original GA  (i.e., the filefolder of `./gatbx`) is based on Shaffield Toolbox. The more information can be found at `./gatbx/readme.txt`



## License

SSGA is free software made available under the MIT License. For details see the LICENSE.md file.
