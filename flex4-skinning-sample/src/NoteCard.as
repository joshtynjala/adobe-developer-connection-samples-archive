package
{
import flash.events.MouseEvent;

import mx.core.IVisualElementContainer;

import spark.components.Button;
import spark.components.supportClasses.SkinnableComponent;
import spark.components.supportClasses.TextBase;

[SkinState("normal")]
[SkinState("disabled")]
public class NoteCard extends SkinnableComponent
{
    public function NoteCard()
    {
        super();
    }
    
    [SkinPart(required="true")]
    public var labelDisplay:TextBase;
    
    [SkinPart(required="false")]
    public var closeButton:Button;
    
    private var _text:String;

    public function get text():String
    {
        return _text;
    }

    public function set text(value:String):void
    {
        if (_text == value)
            return;
        
        _text = value;
        
        if (labelDisplay)
            labelDisplay.text = value;
    }
    
    override public function set enabled(value:Boolean) : void
    {
        if (enabled != value)
            invalidateSkinState();
        
        super.enabled = value;
    }
    
    override protected function getCurrentSkinState() : String
    {
        if (!enabled)
            return "disabled";
        
        return "normal"
    }
    
    override protected function partAdded(partName:String, instance:Object) : void
    {
        super.partAdded(partName, instance);
        
        if (instance == labelDisplay)
            labelDisplay.text = _text;
        
        if (instance == closeButton)
            closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
    }
    
    override protected function partRemoved(partName:String, instance:Object) : void
    {
        super.partRemoved(partName, instance);
        
        if (instance == closeButton)
            closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
    }
    
    protected function closeButton_clickHandler(event:MouseEvent) : void
    {
        event.stopPropagation();
        
        IVisualElementContainer(parent).removeElement(this);
    }

}
}