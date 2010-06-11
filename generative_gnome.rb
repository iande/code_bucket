require 'generative'
require 'gtk2'
require 'cairo'

class LsystemCanvas < Gtk::DrawingArea
  def initialize(axiom, rules)
    super()
    @current_scale = [1.0, 1.0]
    signal_connect('expose_event') do
      #invalid_pixmap
      redraw_widget
    end
  end

  def cairo_image(width, height)
    if @image.nil? || [width, height] != @current_scale
      puts "Constructing new image!"
      @image = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
      img_context = Cairo::Context.new(@image)
      img_context.set_source_rgba(0.5, 0.4, 0.6, 0.9)
      img_context.paint
      img_context.set_source_rgba(0, 0, 0, 0.9)
      img_context.move_to(width / 2.0, height / 2.0)
      img_context.rel_line_to(width.to_f, height.to_f)
      img_context.stroke
      img_context.scale(width, height)
    end
    @image
  end

  def redraw_widget
    return unless window
    context = window.create_cairo_context
    width = allocation.width
    height = allocation.height
    rect = Gdk::Rectangle.new(0, 0, width, height)
    window.begin_paint(rect)
    context.set_source(cairo_image(width, height), 0, 0)
    context.paint
    window.end_paint
  end

  def update_path
    return unless self.window

  end

  def render_pixmap
    alloc = self.allocation
    size = [alloc.width, alloc.height].min
    x = (alloc.width - size) / 2
    y = (alloc.height - size) / 2
    @g_pixmap.draw_arc(@context, false,
      x, y, size, size, 0, 64 * 360)
  end

  def invalidate_pixmap
    @g_pixmap = nil
  end

  def g_pixmap
    unless @g_pixmap
      @g_pixmap = Gdk::Pixmap.new(nil, allocation.width, allocation.height, 32)
      @context = Gdk::GC.new(@g_pixmap)
      render_pixmap
    end
  end
end


Gtk.init

win = Gtk::Window.new
win.set_title('LSystem')
win.signal_connect('delete-event') do |w,e|
  Gtk::main_quit
end
win.set_default_size(300, 300)

win.add(LsystemCanvas.new([], []))

win.show_all


Gtk.main
