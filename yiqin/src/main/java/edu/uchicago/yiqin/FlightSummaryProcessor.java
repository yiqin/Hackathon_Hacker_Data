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

import edu.uchicago.mpcs53013.weatherSummary.FlightSummary;


public abstract class FlightSummaryProcessor {
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

	void processLine(String line, File file) throws IOException {
		try {
			processFlightSummary(flightFromLine(line), file);
			
		} catch(MissingDataException e) {
			// Just ignore lines with missing data
		}
	}

	abstract void processFlightSummary(FlightSummary summary, File file) throws IOException;
	
	BufferedReader getFileReader(File file) throws FileNotFoundException, IOException {
		if(file.getName().endsWith(".csv"))
			return new BufferedReader(new InputStreamReader(new FileInputStream(file), Charset.forName("UTF-8")));
		return new BufferedReader(new InputStreamReader(new FileInputStream(file)));
	}
	
	void processNoaaFile(File file) throws IOException {		
		BufferedReader br = getFileReader(file);
		
		String line = "";
		
		FileReader fileReader = new FileReader(file);
		CSVReader reader = new CSVReader(fileReader);
		
		String [] nextLine;
		int lineNumber = 0;
		while ((nextLine = reader.readNext()) != null) {

			if (nextLine.length == 21) {
				if (nextLine[3].length() < 50) {
					lineNumber++;
					System.out.println("Line # "+lineNumber);
				
					System.out.println(nextLine[3]);
				
					// break;
				}
			}
		}
				
		// don't read by line....
		br.readLine(); // Discard header
		
		// String line;
		
		while((line = br.readLine()) != null) {
			processLine(line, file);
		}
		
		
	}

	void processNoaaDirectory(String directoryName) throws IOException {
		File directory = new File(directoryName);
		File[] directoryListing = directory.listFiles();
		for(File noaaFile : directoryListing)
			processNoaaFile(noaaFile);
	}
	
	
	
	
	
	FlightSummary flightFromLine(String line) throws NumberFormatException, MissingDataException {

		System.out.println(line);
		String[] tokens = line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)", -1);
		System.out.println(tokens[5]);
		FlightSummary summary = new FlightSummary();
		/*
		FlightSummary summary =
		new FlightSummary(Short.parseShort(tokens[0].trim()),
							Byte.parseByte(tokens[2].trim()),
							Byte.parseByte(tokens[3].trim()),
							tokens[6],
							tokens[14],
							tokens[23],
							Long.parseLong(tokens[31].substring(1, tokens[31].length()-1)),
							Long.parseLong(tokens[42].substring(1, tokens[42].length()-1))
							);
		*/
			/*= new FlightSummary(Integer.parseInt(line.substring(0, 6).trim()),
				                      Short.parseShort(line.substring(14, 18).trim()),
				                      Byte.parseByte(line.substring(18, 20).trim()),
				                      Byte.parseByte(line.substring(20, 22).trim()),
				                      tryToReadMeasurement("Mean Temperature", line.substring(24, 30), "9999.9"),
				                      tryToReadMeasurement("Mean Visibility", line.substring(68, 73), "999.9"),
				                      tryToReadMeasurement("Mean WindSpeed", line.substring(78, 83), "999.9"),
				                      line.charAt(132) == '1',
				                      line.charAt(133) == '1',
				                      line.charAt(134) == '1',
				                      line.charAt(135) == '1',
				                      line.charAt(136) == '1',
				                      line.charAt(137) == '1');
				                      */
		return summary;
	}

}
