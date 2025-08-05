/*  
---------------------------------------------------------------------------------------------
DTMF Processor

Copyright 2009 - Nick Kwiatkowski
nick@theFlexGroup.org

This is a reference application.  It is not intended for real-world deployment.  The source
code is being released, as-is, with no warrantee or justification.  

This source code is being released as a Creative Commons Attribution-Noncommercial-Share 
Alike 3.0 United States License.  

----------------------------------------------------------------------------------------------

Application Type:  AIR 2.0 beta
Application Deps:  AIR 2.0 Runtime, Microphone Input

Source Deps:  main

*/			



package com.quetwo.dtmf
{
	import flash.utils.ByteArray;

	public class DTMFprocessor
	{

		/*
		   The following constants are used to find the DTMF tones.  The COL1 is the column Hz that we
		   are searching for, and the COL2 is the row Hz.  The DTMF_LAYOUT is the order that the cols and
		   rows intersect at.
		*/
		
		private static const COL1:Array = [697, 770, 852, 941];
		private static const COL2:Array = [1209, 1336, 1477, 1633];
		private static const DTMF_LAYOUT:Array = [ ["1","2","3","A"] ,
			                                       ["4","5","6","B"] ,
												   ["7","8","9","C"] ,
												   ["*","0","#","D"] ];
		
		private var sampleRate:int;
		private var lastFound:String = "";
		
		public var DTMFToneSensitivity:int = 15;
		
		/**
		 * DTMF Processor Constructor
		 * 
		 * @param sampleRate  This is the sample rate, in frames per second that the application is operating in.
		 * 
		 */		
		public function DTMFprocessor(sampleRate:int = 44100)
		{
			this.sampleRate = sampleRate;
		}
		
		/**
		 * Generates DTMF byteArrays that can be played by the Sound() object.
		 *  
		 * @param length  length, in ms that the tone will be generated for.
		 * @param tone    the string representing the tone that will be generated [0-9, A-D, *, #]
		 * @return        the byteArray that contains the DTMF tone.
		 * 
		 */		
		public function generateDTMF(length:int, tone:String):ByteArray
		{
			var mySound:ByteArray = new ByteArray();
			var neededSamples:int = Math.floor(length * sampleRate / 1000);
			var mySampleCol:Number = 0;
			var mySampleRow:Number = 0;
			
			var hz:Object = findDTMF(tone.charAt(0));
			
			for (var i:int = 0; i < neededSamples; i++)
			{
				mySampleCol = Math.sin(i * hz.col * Math.PI * 2 / sampleRate) * 0.5;
				mySampleRow = Math.sin(i * hz.row * Math.PI * 2 / sampleRate) * 0.5;
				mySound.writeFloat(mySampleRow + mySampleCol);

			}
			return mySound;
		}
		
		/**
		 * Searches a ByteArray (from a Sound() object) for a valid DTMF tone.  
		 *  
		 * @param tone  ByteArray that should contain a valid DTMF tone.
		 * @return      string representation of DTMF tones.  Will return a blank string ('') if nothing is found
		 * 
		 */		
		public function searchDTMF(tone:ByteArray):String
		{
			var position:int = 0;
			var charFound:String = "";
			
			// seed blank values for strongest tone to be found in the byteArray 
			var maxCol:int = -1;
			var maxColValue:int = 0;
			var maxRow:int = -1;
			var maxRowValue:int = 0;
			var foundTones:String = "";
			
			// reset the byteArray to the beginning, should we have gotten it in any other state.
			tone.position = position;
			
			// break up the byteArray in manageable chunks of 8192 bytes.  
			for (var bufferLoop:int =0; bufferLoop < tone.bytesAvailable; bufferLoop =+ 8192)
			{
				position = bufferLoop;
				
				// search for the column tone.
				for (var col:int = 0; col < 4; col++)
				{
					if (powerDB(goertzel(tone,8192,COL1[col],position)) > maxColValue)
					{
						maxColValue = powerDB(goertzel(tone,8192,COL1[col],position));
						maxCol = col;
					}
				}
				
				// search for the row tone.
				for (var row:int = 0; row < 4; row++)
				{
					if (powerDB(goertzel(tone,8192,COL2[row],position)) > maxRowValue)
					{
						maxRowValue = powerDB(goertzel(tone,8192,COL2[row],position));
						maxRow = row;
					}
				}
				
				// was there enough strength in both the column and row to be valid?
				if ((maxColValue < DTMFToneSensitivity) || (maxRowValue < DTMFToneSensitivity))
				{
					charFound = "";
				}
				else
				{
					charFound = DTMF_LAYOUT[maxCol][maxRow];
				}
				
				if (lastFound != charFound)
				{
					trace("Found DTMF Tone:",charFound);
					lastFound = charFound;  // this is so we don't have duplicates.
					foundTones = foundTones + lastFound;
				}
				
			}
			return foundTones;
		}
		
		/**
		 * Converts amplitude to dB (power).  
		 *  
		 * @param value  amplitude value
		 * @return       dB
		 * 
		 */		
		private function powerDB(value:Number):Number
		{
			return 20 * Math.log(Math.abs(value))*Math.LOG10E;
		}
		
		/**
		 * This function returns the amplitude of the a seeked wave in the buffer.
		 *  
		 * @param buffer      the byteArray that is being searched.
		 * @param bufferSize  the size of the buffer that we wish to search.
		 * @param frequency   the frequency (in Hz) that we are searching for.
		 * @param bufferPos   the starting point that we want to search from.
		 * @return            amplitude of the searched frequency, if any.
		 * 
		 */		
		private function goertzel(buffer:ByteArray, bufferSize:int, frequency:int, bufferPos:int):Number
		{
			var skn:Number = 0;
			var skn1:Number = 0;
			var skn2:Number = 0;
			
			buffer.position = bufferPos;
			
			for (var i:int=0; i < bufferSize; i++)
			{
				skn2 = skn1;
				skn1 = skn;
				if (buffer.bytesAvailable > 0)
				skn = 2 * Math.cos(2 * Math.PI * frequency / sampleRate) * skn1 - skn2 + buffer.readFloat();
			}
			
			var wnk:Number = Math.exp(-2 * Math.PI * frequency / sampleRate);
			
			return (skn - wnk * skn1);
		}
		
		/**
		 * Returns the Hz of the string tone that is searched.
		 *  
		 * @param tone  character that is being search for
		 * @return      an untyped object that has col and row properties that contain the Hz of the DTMF tone.
		 * 
		 */		
		private function findDTMF(tone:String):Object
		{
			var myDTMF:Object = new Object();	
			
			switch(tone)
			{
				case "1":
					myDTMF.col = COL1[0];
					myDTMF.row = COL2[0];
					break;
				case "2":
					myDTMF.col = COL1[0];
					myDTMF.row = COL2[1];
					break;
				case "3":
					myDTMF.col = COL1[0];
					myDTMF.row = COL2[2];
					break;
				case "A":
					myDTMF.col = COL1[0];
					myDTMF.row = COL2[3];
					break;
				case "4":
					myDTMF.col = COL1[1];
					myDTMF.row = COL2[0];
					break;
				case "5":
					myDTMF.col = COL1[1];
					myDTMF.row = COL2[1];
					break;
				case "6":
					myDTMF.col = COL1[1];
					myDTMF.row = COL2[2];
					break;
				case "B":
					myDTMF.col = COL1[1];
					myDTMF.row = COL2[3];
					break;
				case "7":
					myDTMF.col = COL1[2];
					myDTMF.row = COL2[0];
					break;
				case "8":
					myDTMF.col = COL1[2];
					myDTMF.row = COL2[1];
					break;
				case "9":
					myDTMF.col = COL1[2];
					myDTMF.row = COL2[2];
					break;
				case "C":
					myDTMF.col = COL1[2];
					myDTMF.row = COL2[3];
					break;	
				case "*":
					myDTMF.col = COL1[3];
					myDTMF.row = COL2[0];
					break;
				case "0":
					myDTMF.col = COL1[3];
					myDTMF.row = COL2[1];
					break;
				case "#":
					myDTMF.col = COL1[3];
					myDTMF.row = COL2[2];
					break;
				case "D":
					myDTMF.col = COL1[3];
					myDTMF.row = COL2[2];
					break;				
				default:
					myDTMF.col = 0;
					myDTMF.row = 0;
			}
			return myDTMF;
		}
	}
}