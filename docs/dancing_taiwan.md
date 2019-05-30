# Dancing Formosan/Taiwan

In [Superformula vase](https://www.thingiverse.com/thing:3639791), I use [`bijection_offset`](https://openhome.cc/eGossip/OpenSCAD/lib-bijection_offset.html) to create an offset shape. Each point is one-to-one. When `bijection_offset` is applied to a complex shape, the offset shape will be tangled.

In order to solve the problem, I tried to write `trim_shape` and `mid_smooth` functions. Here's a demonstration about how to use them. I use [Taiwan](https://en.wikipedia.org/wiki/Geography_of_Taiwan) because it's an irregular shape and will generate tangled shape after offsetting. 

I think this is the area of polygon offset. OpenSCAD has a built-in `offset` for 2D polygon. General algorithms of polygon offset are complex and I'm still studying. Hope I'll figure something out in the future. 

![Dancing Formosan/Taiwan](https://cdn.thingiverse.com/renders/b5/c0/14/30/3a/728021faf98c6acc643978f2564c4467_preview_featured.JPG)

