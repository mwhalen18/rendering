library(rayshader)
library(elevatr)
library(sf)
library(MetBrewer)

#Here, I load a map with the raster package.
kluane = data.frame(y = 61.427113,
                    x = -138.813828) %>% 
  st_as_sf(coords = c("x", "y"), crs = 4326)

kluane = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_USA_1_sf.rds"))

elev = get_elev_raster(kluane, z = 3, source = "gl3")

elmat = raster_to_matrix(elev) %>% 
  resize_matrix(scale = 0.85)

elmat %>% 
  height_shade() %>% 
  add_shadow(texture_shade(elmat, detail = 1/3, contrast = 6, brightness = 3.5), 0) %>% 
  add_shadow(lamb_shade(elmat, zscale = 50),0) %>% 
  #texture_shade(contrast = 5, brightness = 5) %>% 
  #sphere_shade(texture = , sunangle = 180) %>% 
  #add_water(detect_water(elmat, cutoff = 0.998, zscale = 1000)) %>% 
  plot_3d(elmat, windowsize = c(1500,1500), 
          zscale = 10, zoom = 0.75, phi = 89, theta = 0, fov = 0, background = "white")

render_highquality(filename = "output.png", samples = 2000, lightaltitude = 90, lightcolor = "white", lightintensity = 750)




# Michigan ----------------------------------------------------------------
mich = kluane[kluane$NAME_1 == "Michigan",]

elev = get_elev_raster(mich, z = 3, source = "gl3")

elmat = raster_to_matrix(elev) %>% 
  resize_matrix(scale = 0.85)


elmat %>% 
  height_shade() %>% 
  add_shadow(texture_shade(elmat, detail = 1/3, contrast = 6, brightness = 3.5), 0) %>% 
  add_shadow(lamb_shade(elmat, zscale = 50),0) %>% 
  #texture_shade(contrast = 5, brightness = 5) %>% 
  #sphere_shade(texture = , sunangle = 180) %>% 
  #add_water(detect_water(elmat, cutoff = 0.998, zscale = 10)) %>% 
  plot_3d(elmat, windowsize = c(1500,1500), 
          zscale = 10, zoom = 0.75, phi = 89, theta = 0, fov = 0, background = "white")

render_highquality(filename = "maryland.png", samples = 2000, lightaltitude = 90, lightcolor = "white", lightintensity = 750)

