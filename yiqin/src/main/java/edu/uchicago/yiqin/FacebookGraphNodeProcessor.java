package edu.uchicago.yiqin;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPInputStream;

import com.opencsv.CSVReader;

import edu.uchicago.mpcs53013.facebookGraphNode.FacebookGraphNode;
import edu.uchicago.mpcs53013.weatherSummary.FlightSummary;


public abstract class FacebookGraphNodeProcessor {
	static class MissingDataException extends Exception {

	    public MissingDataException(String message) {
	        super(message);
	    }

	    public MissingDataException(String message, Throwable throwable) {
	        super(message, throwable);
	    }

	}
	
	static double tryToReadMeasurement(String name, String s, String missing) throws MissingDataException {
		if(s.equals(missing))
			throw new MissingDataException(name + ": " + s);
		return Double.parseDouble(s.trim());
	}

	void processLine(String [] line, File file) throws IOException {
		try {
			processFlightSummary(flightFromLine(line), file);
			
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}

	abstract void processFlightSummary(FacebookGraphNode summary, File file) throws IOException;
	
	BufferedReader getFileReader(File file) throws FileNotFoundException, IOException {
		if(file.getName().endsWith(".csv"))
			return new BufferedReader(new InputStreamReader(new FileInputStream(file), Charset.forName("UTF-8")));
		return new BufferedReader(new InputStreamReader(new FileInputStream(file)));
	}
	
	void processNoaaFile(File file) throws IOException {		
				
		FileReader fileReader = new FileReader(file);
		CSVReader reader = new CSVReader(fileReader);
		
		String [] nextLine;
		int lineNumber = 0;
		reader.readNext();
		while ((nextLine = reader.readNext()) != null) {

			if (nextLine.length == 21) {
				if (nextLine[3].length() < 50 && nextLine[5].length() < 20) {
					lineNumber++;
					// System.out.println("Line # "+lineNumber);
				
					// System.out.println(nextLine[3]);
					processLine(nextLine, file);
				}
			}
		}
	}

	void processNoaaDirectory(String directoryName) throws IOException {
		File directory = new File(directoryName);
		File[] directoryListing = directory.listFiles();
		for(File noaaFile : directoryListing)
			processNoaaFile(noaaFile);
	}
	
	
	FacebookGraphNode flightFromLine(String [] line) throws NumberFormatException, MissingDataException {
		int level = 0;
		if(line[1].length() != 0) {
			// level = Integer.parseInt(line[1]);
		}
		FacebookGraphNode summary = 
				new FacebookGraphNode(line[0], level, line[2], line[3],line[4],
													line[5], line[6], line[7],line[8],
													line[9], line[10], line[11],line[12],
													line[13], line[14], line[15],line[16],
													line[17], line[18], line[19],line[20]
													);
		
		return summary;
	}

}
