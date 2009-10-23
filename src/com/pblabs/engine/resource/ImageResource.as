/*******************************************************************************
 * PushButton Engine
 * Copyright (C) 2009 PushButton Labs, LLC
 * For more information see http://www.pushbuttonengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.engine.resource
{
    import com.pblabs.engine.PBE;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    
    [EditorData(extensions="jpg,png,gif")]
    
    /**
     * This is a Resource subclass for image data.
     */
    public class ImageResource extends Resource
    {
        /**
         * Once the resource has succesfully loaded, this contains a bitmap representing
         * the loaded image.
         */
        public function get image():Bitmap
        {
            return _image;
        }
        
        override public function initialize(data:*):void
        {
            if (data is Bitmap)
            {
            	// Directly load embedded resources if they gave us a Bitmap.
                onContentReady(data);
                onLoadComplete();
                return;
            }
            else
            if (data is BitmapData)
            {
            	// If they gave us a BitmapData object create a new Bitmap from that
                onContentReady(new Bitmap(data as BitmapData));
                onLoadComplete();            	
            }
            else
            if (data is Sprite)
            {
            	// get sprite's targetSpace
            	var targetSpace:DisplayObject;
            	((data as Sprite).parent)?targetSpace=(data as Sprite).parent:targetSpace=PBE.mainStage;
            	// get sprite's rectangle 
            	var spriteRect:Rectangle = (data as Sprite).getBounds(targetSpace);
            	// create transform matrix for drawing this sprite;
            	var m:Matrix = new Matrix();
            	m.translate((spriteRect.x*-1),(spriteRect.y*-1));            	  
            	// If they gave us a Sprite draw this onto a transparent filled BitmapData object
            	var bmd:BitmapData = new BitmapData(spriteRect.width,spriteRect.height,true,0x000000);
            	bmd.draw((data as Sprite),m);
            	// Use the BitmapData to create a new Bitmap for this ImageResource 
                onContentReady(new Bitmap(bmd));
                onLoadComplete();
                return;            	
            }
            
            // Otherwise it must be a ByteArray, pass it over to the normal path.
            super.initialize(data);
        }
        
        /**
         * @inheritDoc
         */
        override protected function onContentReady(content:*):Boolean 
        {
            if(content)
                _image = content as Bitmap;
            return _image != null;
        }
        
        private var _image:Bitmap = null;
    }
}