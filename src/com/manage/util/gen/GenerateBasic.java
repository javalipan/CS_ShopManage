package com.manage.util.gen;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;

/**
 * <ul>
 * <li>林啸虎 2015年11月12日 新建</li>
 * <li>{@link #方法名自动提示}功能描述,方便查找方法</li>
 * </ul>
 *
 */
public class GenerateBasic {
	
	public static void main(String[] args) throws Exception {
		// 可传入多张表
		generateClazzOne("t_member,BaseMember","t_goods,BaseGoods","t_goods_detail,BaseGoodsDetail","t_imgs,BaseImgs","t_level_setting,BaseLevelSetting","t_order,BaseOrder","t_order_detail,BaseOrderDetail","t_point_log,BasePointLog","t_brand,BaseBrand");
	}
	
	public static void generateClazzOne(String... tableName) throws Exception {
		for (int i = 0; i < tableName.length; i++) {
			String str = tableName[i];
			if(str.indexOf(",")>=0){
				new GenerateBasic().doBasicBusiness(str.split(",")[0],str.split(",")[1]);
			}
			else{
				new GenerateBasic().doBasicBusiness(str,str);
			}
			System.err.println("生成完成.... > " + (i + 1) + "/" + tableName.length);
		}
		
	}
	
	CommonDaoImpl cdi;

	/**
	 * 生成基础业务层
	 * 
	 * @param pack
	 *            包名 相对于当前文件
	 * 
	 */
	public void doBasicBusiness(String tableName,String cname) {
		BasicDataSource dataSource=new BasicDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql://localhost:3306/shop?characterEncoding=utf-8");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
		dataSource.setValidationQuery("select 'TEST' from DUAL");
		dataSource.setTestOnBorrow(true);
		dataSource.setMaxActive(100);
		dataSource.setMaxIdle(20);
		dataSource.setMaxWait(1000);
		JdbcTemplate jdbcTemplate1=new JdbcTemplate(dataSource);
		

		cdi = new CommonDaoImpl();
		cdi.setJdbcTemplate(jdbcTemplate1);

		try {

			String property = System.getProperty("user.dir");
			File propertyFile=new File(property);

			File basemodelFile = new File( propertyFile.getParentFile().getAbsolutePath()+ "/ClothesShop/src/com/block/common/model/base/"+ cname + ".java");
			File modelFile = new File( propertyFile.getParentFile().getAbsolutePath()+ "/ClothesShop/src/com/block/common/model/"+ cname.replace("Base", "") + ".java");

			createFolder(modelFile);
			createFile(basemodelFile);
			createFile(modelFile);

			writeModelBase(basemodelFile,tableName,cname);
			writeModel(modelFile,tableName,cname);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private List<Map<String, String>> getColumn(String tableName) throws Exception{
		List<Map<String, Object>> tableNames = cdi.selectList("show full fields from " + tableName, null);
		List<Map<String, String>> keys = new ArrayList<Map<String,String>>();
		for (Map<String, Object> map : tableNames) {
			String column = map.get("Field").toString();
			Map<String, String> key=new HashMap<String, String>();
			key.put("key", column);
			key.put("comment", map.get("Comment").toString());
			key.put("type", map.get("Type").toString());
			keys.add(key);
		}
		return keys;
	}
	
	public String getJavaType(String type){
		if(type.toUpperCase().startsWith("VARCHAR")){
			return "String";
		}
		else if(type.toUpperCase().startsWith("CHAR")){
			return "String";
		}
		else if(type.toUpperCase().startsWith("TEXT")){
			return "String";
		}
		else if(type.toUpperCase().startsWith("INTEGER")){
			return "Integer";
		}
		else if(type.toUpperCase().startsWith("TINYINT")){
			return "Integer";
		}
		else if(type.toUpperCase().startsWith("SMALLINT")){
			return "Integer";
		}
		else if(type.toUpperCase().startsWith("BIGINT")){
			return "Long";
		}
		else if(type.toUpperCase().startsWith("FLOAT")){
			return "Float";
		}
		else if(type.toUpperCase().startsWith("DOUBLE")){
			return "Double";
		}
		else if(type.toUpperCase().startsWith("DECIMAL")){
			return "Double";
		}
		else if(type.toUpperCase().startsWith("DATE")){
			return "Date";
		}
		else if(type.toUpperCase().startsWith("TIME")){
			return "Date";
		}
		else if(type.toUpperCase().startsWith("DATETIME")){
			return "Date";
		}
		else if(type.toUpperCase().startsWith("TIMESTAMP")){
			return "Date";
		}
		else if(type.toUpperCase().startsWith("INT")){
			return "Integer";
		}
		return "";
	}
	
	/** 
	* 生成实体
	* @param file :文件
	* @param tableName ：表名
	* @param cname ：类名
	* @throws Exception    
	* @author lipan@cqrainbowsoft.com    
	*/
	private void writeModel(File file,String tableName,String cname) throws Exception{
		PrintWriter printWriter = new PrintWriter(file);
		printWriter.println("package com.block.common.model;");
		printWriter.println("");
		printWriter.println("import com.block.common.model.base."+cname+";");

		printWriter.println("/**");
		printWriter.println(" * Generated by JFinal.");
		printWriter.println("*/");
		printWriter.println("@SuppressWarnings(\"serial\")");
		
		printWriter.println("public class "+cname.replace("Base", "")+" extends "+cname+"<"+cname.replace("Base", "")+">{");
		printWriter.println();
		printWriter.println("\tpublic static final "+cname.replace("Base", "")+" dao = new "+cname.replace("Base", "")+"();");
		
		printWriter.println();
		printWriter.println("}");
		printWriter.flush();
		printWriter.close();
	}
	
	private void writeModelBase(File file,String tableName,String cname) throws Exception{
		PrintWriter printWriter = new PrintWriter(file);
		printWriter.println("package com.block.common.model.base;");
		printWriter.println("");
		printWriter.println("import com.jfinal.plugin.activerecord.Model;");
		printWriter.println("import com.jfinal.plugin.activerecord.IBean;");
		
		printWriter.println("import java.util.*;");
		printWriter.println();
		
		printWriter.println("/**");
		printWriter.println(" * Generated by JFinal.");
		printWriter.println("*/");
		printWriter.println("@SuppressWarnings(\"serial\")");
		printWriter.println("public class "+cname+" <M extends "+cname+"<M>> extends Model<M> implements IBean {");
		printWriter.println();
		
		List<Map<String, String>> keys=getColumn(tableName);
		for(Map<String, String> key:keys){
			String column=key.get("key");
			String columnMethod=String.valueOf(column.charAt(0)).toUpperCase()+column.substring(1);
			String comment=StringUtils.isBlank(key.get("comment"))?key.get("key"):key.get("comment");
			printWriter.println();
			printWriter.println("\t/**");
			printWriter.println("\t *获取"+comment);
			printWriter.println("\t */");
			printWriter.println("\tpublic "+getJavaType(key.get("type"))+" get"+columnMethod+"() {");
			printWriter.println("\t\treturn get(\""+column+"\");");
			printWriter.println("\t}");
			printWriter.println();
			printWriter.println("\t/**");
			printWriter.println("\t *设置"+comment);
			printWriter.println("\t */");
			printWriter.println("\tpublic void set"+columnMethod+"("+getJavaType(key.get("type"))+" "+column+") {");
			printWriter.println("\t\tset(\""+column+"\","+column+");");
			printWriter.println("\t}");
		}
		
		printWriter.println();
		printWriter.println("}");
		printWriter.flush();
		printWriter.close();
	}

	/**
	 * 创建文件夹
	 * <ul>
	 * <li>林啸虎 2015年11月12日 新建</li>
	 * </ul>
	 * 
	 * @param file
	 */
	private void createFolder(File file) {
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}
	}

	/**
	 * 创建文件
	 * <ul>
	 * <li>林啸虎 2015年11月12日 新建</li>
	 * </ul>
	 * 
	 * @param file
	 * @throws IOException
	 */
	private void createFile(File file) throws IOException {
		if (!file.exists()) {
			file.createNewFile();
		}
	}

}
