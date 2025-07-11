package skins
{
import skins.assets.RoundedButton;

import spark.skins.mobile.ButtonSkin;

public class RoundedButtonSkin extends ButtonSkin
{
    private var colorized:Boolean = false;
    
    public function RoundedButtonSkin()
    {
        super();
        
        // replace FXG asset classes
        upBorderSkin = skins.assets.RoundedButton;
        downBorderSkin = skins.assets.RoundedButton;
        
        measuredDefaultHeight = 44;
        measuredDefaultWidth = 220;
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // omit call to super.drawBackground() to apply tint instead and don't draw fill
        var chromeColor:uint = getStyle("chromeColor");
        
        if (colorized || (chromeColor != 0xDDDDDD))
        {
            // apply tint instead of fill
            applyColorTransform(border, 0xDDDDDD, chromeColor);
            
            // if we restore to original color, unset colorized
            colorized = (chromeColor != 0xDDDDDD);
        }
    }
}
}
