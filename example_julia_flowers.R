message("All files get saved in C:/Users/spack/Documents/julia_flowers")
message("but you must move them to avoid losing them [overwritten]")

#  the Julia set consists of values such that an arbitrarily small perturbation 
#  can cause drastic changes in the sequence of iterated function value


library(rbenchmark)

# default exp and ind parameters
#                                        test replications elapsed relative user.self sys.self user.child sys.child
# 1 one <- flower_maker()            1  642.18        1    487.37   130.23         NA        NA
one <- flower_maker()
# Decide to save the plot? Use (don't forget quotation marks!)
saveplot(one, "example1")
#                                         test replications elapsed relative user.self sys.self
# 1 two <- flower_maker(savefile = "example2")            1  845.61        1    550.55   243.53

# Why not save the plot and create it in one line?
benchmark(two <- flower_maker(savefile = "example2"), replications = 1)
# You can adjust the exp, ind, and ite parameters
# [exp = exponent, ind = independent term, and ite = iterations]
# test replications elapsed relative user.self sys.self user.child sys.child
# 1 three <- flower_maker(exp = 3, ind = 0.3, ite = 9, savefile = "example3")            1  579.01        1    365.71   193.04         NA        NA
benchmark(three <- flower_maker(exp = 3, ind = 0.3, ite = 9, savefile = "example3"), replications = 1)
# That took a long time. We can make tflowers faster by not changing ite'
# test replications elapsed relative user.self sys.self user.child sys.child
# 1 four <- flower_maker(exp = 5, ind = 0.5, savefile = "example3")            1  701.33        1    411.79   269.01         NA        NA
benchmark(four  <- flower_maker(exp = 5, ind = 0.5, savefile = "example3"), replications = 1)
# The last flower re-used ite = 9