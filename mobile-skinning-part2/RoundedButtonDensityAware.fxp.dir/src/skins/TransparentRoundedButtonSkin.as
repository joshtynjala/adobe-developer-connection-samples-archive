package skins
{
import mx.core.DPIClassification;

import skins.assets160.TransparentRoundedButton_up;
import skins.assets240.TransparentRoundedButton_down;
import skins.assets240.TransparentRoundedButton_up;
import skins.assets320.TransparentRoundedButton_down;
import skins.assets320.TransparentRoundedButton_up;

import spark.skins.mobile.ButtonSkin;

public class TransparentRoundedButtonSkin extends ButtonSkin
{
    public function TransparentRoundedButtonSkin()
    {
        super();
        
        switch (applicationDPI)
        {
            case DPIClassification.DPI_320:
            {
                upBorderSkin = skins.assets320.TransparentRoundedButton_up;
                downBorderSkin = skins.assets320.TransparentRoundedButton_down;
                
                break;
            }
            case DPIClassification.DPI_240:
            {
                upBorderSkin = skins.assets240.TransparentRoundedButton_up;
                downBorderSkin = skins.assets240.TransparentRoundedButton_down;
                
                break;
            }
            default:
            {
                // default DPI_160
                upBorderSkin = skins.assets160.TransparentRoundedButton_up;
                downBorderSkin = skins.assets160.TransparentRoundedButton_down;
                
                break;
            }
        }
    }
    
    override protected function drawBackground(unscaledWidth:Number, unscaledHeight:Number):void
    {
        // transparent button, do nothing
    }
}
}