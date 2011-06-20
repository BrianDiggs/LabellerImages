library("ggplot2")

mpg2 <- subset(mpg, cyl != 5 & drv %in% c("4", "f"))
p <- qplot(cty, hwy, data = mpg2)

p + facet_grid(drv ~ cyl)
ggsave(filename = "base.png")

p + facet_grid(drv ~ cyl, labeller=label_value)
ggsave(filename = "label_value.png")

p + facet_grid(drv ~ cyl, labeller=label_both)
ggsave(filename = "label_both.png")

mpg3 <- transform(mpg2,
    cyl = factor(cyl, levels=c(4,6,8), labels=c("alpha", "sqrt(x, y)", "sum(x[i], i==1, n)")))
(p %+% mpg3) + facet_grid(drv ~ cyl, labeller=label_parsed)
ggsave(filename = "label_parsed.png")

p + facet_grid(drv ~ cyl, labeller=label_bquote())
ggsave(filename = "label_bquote.png")

p + facet_grid(drv ~ cyl, labeller=label_bquote(expr = alpha[.(x)]))
ggsave(filename = "label_bquote2.png")

label_wrap <- function(variable, value) {
  laply(strwrap(as.character(value), width=25, simplify=FALSE),
        paste, collapse="\n")
}

label_wrap_gen <- function(width = 25) {
    function(variable, value) {
      laply(strwrap(as.character(value), width=width, simplify=FALSE),
            paste, collapse="\n")
    }
}

mpg4 <- transform(mpg2,
    cyl = factor(cyl, levels=c(4,6,8),
        labels=c("These are cars that have 4 cylinders",
            "These are other cars that have 6 cylinders",
            "Here are some 8 cylinder cars if you want that may cylinders")))

(p %+% mpg4) + facet_grid(drv ~ cyl, labeller=label_wrap)
ggsave(filename = "label_wrap.png")

(p %+% mpg4) + facet_grid(drv ~ cyl, labeller=label_wrap_gen(width=15))
ggsave(filename = "label_wrap_gen.png")

(p %+% mpg4) + facet_grid(~ drv + cyl, labeller=label_wrap_gen(width=15))
ggsave(filename = "label_wrap_gen2.png")

