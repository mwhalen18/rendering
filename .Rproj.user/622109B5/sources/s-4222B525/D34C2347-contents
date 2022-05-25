library(rayshader)
library(elevatr)
library(sf)
library(MetBrewer)
library(dplyr)
library(tidyr)

usa = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_USA_2_sf.rds"))
#can = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_CAN_2_sf.rds"))
#
#mode.num = function(x) {
#  u = unique(x) 
#  tab = tabulate(match(x,u)) 
#  u[tab == max(tab)]
#}


# Michigan ----------------------------------------------------------------
mich = usa[usa$NAME_1 == "Michigan",]
#mich = mich[mich$NAME_2 %in% c("Lake Superior"), ]


#temp = mich[mich$NAME_2 %in% counties[1], ]
elev = get_elev_raster(mich, z = 6, src = "aws")

elmat = raster_to_matrix(elev) %>% 
  resize_matrix(scale = 1)

elmat[elmat < 179] = 179
#elmat[elmat %in% 176:184] = 0

elmat[is.na(elmat)] = min(elmat, na.rm = TRUE)
sum(is.na(elmat))
#elmat = elmat-400

#elmat = scale(elmat)
texture = (grDevices::colorRampPalette(c("#ffffff", "#f8f4f1", "#ece7e3", "#dfd2ca", "#d2c2b5", "#bba492", "#3c2f26"), bias = 5, interpolate = "linear"))(256)


elmat %>% 
  height_shade(texture = texture) %>% 
  add_shadow(texture_shade(elmat, detail = 1, contrast = 4, brightness = 8), max_darken = 1) %>% 
  add_shadow(lamb_shade(elmat, zscale = 8),max_darken = 0.1) %>% 
  #add_water(detect_water(elmat, cutoff = 0.9999, zscale = 10), color = "#3ea1f1") %>% 
  plot_3d(elmat, windowsize = c(1500,1500), 
          zscale = 1, zoom = 0.75, phi = 89, theta = 0, fov = 0, background = "white")
#1500 x 1043
rm(usa, elev, mich)
gc()
height = 4000
width = as.integer(height*1.438159)
render_highquality(filename = "~/Dropbox (University of Michigan)/mich_test.png", 
                   samples = 5000, 
                   height = height,
                   width = width,
                   lightaltitude = 85, 
                   lightdirection = 315, 
                   lightcolor = "white", 
                   lightintensity = 700,
                   #title_text = "General Chart \n of \n The Great Lakes", 
                   #title_position = "north", 
                   #title_font = "Palatino",
                   #title_offset = c(0,120),
                   clear = TRUE)
