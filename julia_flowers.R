library(tidyverse)
library(colourlovers)
writedir <- 'C:/Users/spack/Documents/julia_flowers/'

saveplot <- function(plot_var, savefile){
  ggsave(paste0(writedir, savefile, ".png"), plot_var, height=4, width=4, units='in', dpi=1200)
}

# Set default ite parameter to 7 as in the original code
ite_export <- 7

flower_maker <- function(exp = 5, ind = 0.481, ite = ite_export, savefile = NULL){

# The function
f <- function(x, y) x^exp + ind

# Reduce approach to iterate
julia <- function (z, n) Reduce(f, rep(1,n), accumulate = FALSE, init = z)

# This is the grid of complex: 3000x3000 between -2 and 2
complex_grid <- outer(seq(-2, 2, length.out = 3000), 1i*seq(-2, 2, length.out = 3000),'+') %>% as.vector()

# Iteration over grid of complex
message("Rick Pack: This step can take quite a while, so storing complex_grid")
message("for reuse as long as ite parameter not changed")
if(!exists('datos') || ite == ite_export){
complex_grid %>% sapply(function(z) julia(z, n=ite)) -> datos
}

# Pick a top random palette from COLOURLovers  
palette <- sample(clpalettes('top'), 1)[[1]] %>% swatch %>% .[[1]] %>% unique() %>% colorRampPalette()

# Build the data frame to do the plt (removing complex with INF modulus)
df <- data_frame(x=Re(complex_grid), 
                 y=Im(complex_grid), 
                 z=Mod(datos)) %>% 
  filter(is.finite(z)) %>% 
  mutate(col=cut(z,quantile(z, probs = seq(0, 1, 1/10)), include.lowest = TRUE))

# Limits of the data to frame the drawing
Mx=max(df$x)+0.2
mx=min(df$x)-0.2
My=max(df$y)+0.2
my=min(df$y)-0.2

# Here comes the magic of ggplot
df %>% 
  ggplot() + 
  geom_tile(aes(x=x, y=y, fill=col, colour = col)) + 
  scale_x_continuous(limits = c(mx, Mx), expand=c(0,0))+
  scale_y_continuous(limits = c(my, My), expand=c(0,0))+
  scale_colour_manual(values=palette(10)) +
  theme_void()+
  coord_fixed()+
  theme(legend.position = "none") -> plot
# Show the flower
print(plot)

# Do you like the drawing? Save it!
if(!is.null(savefile)){
 ggsave(paste0(writedir, savefile, ".png"), plot, height=4, width=4, units='in', dpi=1200)
}

# If code completes, assign ite parameter to the global environment for faster
# plot production
assign("ite_export", ite, envir = .GlobalEnv)
assign("datos", datos, envir = .GlobalEnv)

invisible(plot)
}