library("ggplot2")

mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))
p <- qplot(cty, hwy, data = mpg2)

p + facet_grid(drv ~ cyl)
ggsave(filename = "base.png")

## is the same as if the default labeller is set

## p + facet_grid(drv ~ cyl, labeller=label_value)

## Note that the argument to labeller can also be the quoted name of a function which is a valid labeller

## p + facet_grid(drv ~ cyl, labeller="label_value")

## If a different labeller is used, the facet labels change

## p + facet_grid(drv ~ cyl, labeller=label_both)

## Now instead of the facet labels at the top being "4", "6", and "8", they are "cyl: 4", "cyl: 6", and "cyl: 8". Similarly, the vertical labels are "drv: 4" and "drv: f". There is not a way to set the labels for the horizontal and vertical separately.

## For this example, label_parsed does not do anything interesting since the values of the facet variables are not plotmath expressions that would get formatted any differently.

## mpg3 <- transform(mpg2,
##     cyl = factor(cyl, levels=c(4,6,8), labels=c("alpha", "sqrt(x, y)", "sum(x[i], i==1, n)")))
## (p %+% mpg3) + facet_grid(drv ~ cyl, labeller=label_parsed)

## Here, the (top) facet labels are the greek letter alpha, the y-th root of x, and the sum over i from 1 to n of x sub i.

## p + facet_grid(drv ~ cyl, labeller=label_bquote())

## First, note that the argument to labeller is not the function label_bquote, but rather the function that is returned when calling label_bquote (with the default arguments). This is because label_bquote is a function which returns a labeller rather than being a labeller itself. The default expression is a greek beta raised to the power of the levels of the factor being faceted on. This expression can be changed with the expr arugment to label_bquote. In the expression, x will be substituted for the value of the level of the factor. For example, to make the facet labels an alpha with the level of the factor as a subscript:

## p + facet_grid(drv ~ cyl, labeller=label_bquote(expr = alpha[.(x)]))

## Writing new labellers

## The structure of a labeller is a function that takes two arguments: variable and value. variable is a length 1 character vector with the name of the variable which is being faceted on. value is the ordered (not necessarily unique) values of the facets. If the faceting variable is a factor, this is a factor including the used levels (note that there may be additional levels to the factor which are not part of the faceting, but were levels of the factor to begin with; thus it is the character representation of the factor which is relevant, not the levels). If the faceting variable is a character variable or a numeric variable, then value is a simple vector of the (not necessarily unique, but ordered) values of the faceting variable. What gets passed as value need not be unique because levels can be repeated in the case of nested faceting; see the last example.

## The output of labeller varies quite a lot. All four built in labellers return different structures, all of which are apparently acceptable.

##     A factor whose character representation is the labels
##     A character vector that is the labels
##     A list of expressions, each element of which is one label
##     A list of calls, each element of which is one label

## The following is an example of a labeller which wraps long labels at a fixed character count so that they take up less space. This can be useful since the space for facets is not expanded to guarantee that the entire label is visible. (This example is inspired by and derived from this thread on the mailing list.)

## label_wrap <- function(variable, value) {
##   laply(strwrap(as.character(value), width=25, simplify=FALSE),
##         paste, collapse="\n")
## }

## Alternatively, a label_wrap generator can be made which allows parametrization of the width of wrapping. I prefer to name it differently to differentiate that it is a generator of labellers, not a labeller itself.

## label_wrap_gen <- function(width = 25) {
##     function(variable, value) {
##       laply(strwrap(as.character(value), width=width, simplify=FALSE),
##             paste, collapse="\n")
##     }
## }

## An example of the usage of these would be

## mpg4 <- transform(mpg2,
##     cyl = factor(cyl, levels=c(4,6,8),
##         labels=c("These are cars that have 4 cylinders",
##             "These are other cars that have 6 cylinders",
##             "Here are some 8 cylinder cars if you want that may cylinders")))

## (p %+% mpg4) + facet_grid(drv ~ cyl, labeller=label_wrap)

## (p %+% mpg4) + facet_grid(drv ~ cyl, labeller=label_wrap_gen(width=15))

## (p %+% mpg4) + facet_grid(~ drv + cyl, labeller=label_wrap_gen(width=15))
