package edu.uchicago.yiqin;

import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.SequenceFile.CompressionType;
import org.apache.hadoop.io.SequenceFile.Writer;
import org.apache.thrift.TException;
import org.apache.thrift.TSerializer;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;

import edu.uchicago.mpcs53013.facebookGraphNode.FacebookGraphNode;

public class SerializeFacebookGraphNode {
	static TProtocol protocol;
	
	public static void main(String[] args) {
		try {
			Configuration conf = new Configuration();
			conf.addResource(new Path("/etc/hadoop/conf/core-site.xml"));
			conf.addResource(new Path("/etc/hadoop/conf/hdfs-site.xml"));
			final Configuration finalConf = new Configuration(conf);
			final FileSystem fs = FileSystem.get(conf);
			final TSerializer ser = new TSerializer(new TBinaryProtocol.Factory());
			
			FacebookGraphNodeProcessor processor = new FacebookGraphNodeProcessor() {
				Map<Integer, SequenceFile.Writer> yearMap = new HashMap<Integer, SequenceFile.Writer>();
				Pattern yearPattern = Pattern.compile("(\\d+)");
				
				Writer getWriter(File file) throws IOException {
					Matcher yearMatcher = yearPattern.matcher(file.getName());
					if(!yearMatcher.find())
						throw new IllegalArgumentException("Bad file name. Can't find year: " + file.getName());
					int year = Integer.parseInt(yearMatcher.group(1));
					if(!yearMap.containsKey(year)) {
						yearMap.put(year, 
								SequenceFile.createWriter(finalConf,
										SequenceFile.Writer.file(
												new Path("/mnt/scratch/yiqin/Facebook_Graph_data")),
										SequenceFile.Writer.keyClass(IntWritable.class),
										SequenceFile.Writer.valueClass(BytesWritable.class),
										SequenceFile.Writer.compression(CompressionType.NONE)));
					}
					return yearMap.get(year);
				}

				@Override
				void processFlightSummary(FacebookGraphNode summary, File file) throws IOException {
					try {
						getWriter(file).append(new IntWritable(1), new BytesWritable(ser.serialize(summary)));;
					} catch (TException e) {
						throw new IOException(e);
					}
				}
			};
			processor.processNoaaDirectory(args[0]);
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
