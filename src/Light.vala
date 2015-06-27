using Gtk;
using Posix;
// using Soup;

public class Light : Box {
	private int number;
	private HueBridge bridge;
	
	private Switch lightSwitch;
	private Scale scaleBri;
	private Scale scaleSat;

	// initialize a Box for a light
	public Light(int number, string name, int64 hue, int64 sat, int64 bri, 
			bool lswitch, HueBridge bridge) {
		this.spacing = 16;
		this.margin_top = 8;
		this.margin_bottom = 8;
		this.border_width = 1;
		this.valign = Align.END;
		
		this.number = number;
		this.bridge = bridge;
		
		// number
		Label lightNumber = new Label("<b>" + number.to_string() + "</b>");
		lightNumber.use_markup = true;
		lightNumber.valign = Align.BASELINE;
		this.pack_start(lightNumber, false, false, 8);
		
		// hue
		Gtk.Button lightHue = new Gtk.Button.from_icon_name(
			"dialog-information-symbolic", 
			Gtk.IconSize.SMALL_TOOLBAR
		);
		this.pack_start(lightHue, false, false, 0);
		
		// debug
		debug("[Light] name = " + name);
		
		// name
		Label lightName = new Label(name);
		lightName.valign = Align.BASELINE;
		this.pack_start(lightName, false, false, 4);
		
		Label emptyLabel = new Label(" ");
		this.pack_start(emptyLabel, true, false, 0);
		
		// switch: on, off 
		lightSwitch = new Switch();
		lightSwitch.active = lswitch;
		lightSwitch.margin_bottom = 4;
		lightSwitch.valign = Align.END;
		
		// saturation
		scaleSat = new Scale.with_range(Gtk.Orientation.HORIZONTAL, 1, 254, 1);
		scaleSat.set_value((double) sat);
		scaleSat.draw_value = false;
		scaleSat.width_request = 128;
		scaleSat.margin_bottom = 4;
		scaleSat.valign = Align.END;
		this.pack_start(scaleSat, false, false, 0);
		scaleSat.value_changed.connect(() => {
			if (lightSwitch.active) {
				debug("[Light." + this.number.to_string() + "] sat = " 
					+ getSat().to_string());
				bridge.putState(
					this.number, 
					"{\"sat\": " + getSat().to_string() + "}"
				);
			}
		});
		
		// brightness
		scaleBri = new Scale.with_range(Gtk.Orientation.HORIZONTAL, 1, 254, 1);
		scaleBri.set_value((double) bri);
		scaleBri.draw_value = false;
		scaleBri.width_request = 254;
		scaleBri.margin_bottom = 4;
		scaleBri.valign = Align.END;
		this.pack_start(scaleBri, false, false, 0);
		scaleBri.value_changed.connect(() => {
			if (lightSwitch.active) {
				debug("[Light." + this.number.to_string() + "] bri = " 
					+ getBri().to_string());
				bridge.putState(
					this.number, 
					"{\"bri\": " + getBri().to_string() + "}"
				);
			}
		});
		
		// switch: on, off
		this.pack_start(lightSwitch, false, false, 8);
		lightSwitch.notify["active"].connect(() => {
			toggleSwitch();
		});
	}
	
	private int getBri() {
		return (int) scaleBri.get_value();
	}
	
	private int getSat() {
		return (int) scaleSat.get_value();
	}
	
	private void toggleSwitch() {
		if (lightSwitch.active) {
			// send all light attributes to bridge
			debug("[Light.toggleSwitch] switch " + this.number.to_string() 
				+ " on");
			bridge.putState(
				this.number, 
				"{\"on\":true,\"bri\":" + getBri().to_string() + ",\"sat\": " 
					+ getSat().to_string() + "}"
			);
		} 
		else {
			debug("[Light.toggleSwitch] switch " + this.number.to_string() 
				+ " off");
			bridge.putState(this.number, "{\"on\":false}");
		}
	}
	
//	private void deleteLight() {
//		this.get_parent().destroy();
//	}
}
