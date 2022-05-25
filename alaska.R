library(rayshader)
library(elevatr)
library(sf)
library(dplyr)

usa = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_USA_2_sf.rds"))

canada = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_CAN_2_sf.rds"))
little_usa = readRDS(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_USA_2_sf.rds"))



yukon = canada[canada$NAME_1 %in% c("Yukon", "British Columbia", "Northwest Territories", "Nun"),]
states = little_usa[little_usa$NAME_1 %in% c("Washington", "Oregon", "California"),]

# Alaska ------------------------------------------------------------------

alaska = usa[usa$NAME_1 == "Alaska",] 
alaska = alaska[alaska$NAME_2 != "Aleutians West", ]

alaska = bind_rows(alaska)

elev = get_elev_raster(alaska, z = 3)

elmat = raster_to_matrix(elev) %>% 
  resize_matrix(scale = 0.1)

texture = (grDevices::colorRampPalette(c("#000000", "#78c864", "#D9CC9A", "#d8d3bc", "#ffffff", "#78c864")))(256)

elmat %>% 
  height_shade() %>% 
  add_shadow(texture_shade(elmat, detail = 1/3, contrast = 6, brightness = 3.5), 0) %>% 
  add_shadow(lamb_shade(elmat, zscale = 50),0) %>% 
  #texture_shade(contrast = 5, brightness = 5) %>% 
  #sphere_shade(texture = , sunangle = 180) %>% 
  #add_water(detect_water(elmat, cutoff = 0.998, zscale = 10)) %>% 
  plot_3d(elmat, windowsize = c(1500,1500), 
          zscale = 10, zoom = 0.75, phi = 89, theta = 0, fov = 0, background = "white")
#1500 x 1043

height = 2000
width = as.integer(height*1.438159)
#render_highquality(filename = "test.png", samples = 10, lightaltitude = 90, lightcolor = "white", lightintensity = 750, height = 2000, width = 2500)
render_snapshot(title_text = "The Great Lakes", 
                title_position = "north", 
                title_font = "Palatino",
                title_offset = c(0,200))
