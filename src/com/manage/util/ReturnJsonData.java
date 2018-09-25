package com.manage.util;

import java.beans.BeanInfo;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;

/**
 * RTMS 控制层JSON数据统一处理
* 项目名称：RTMS2014<br>
* 类名称：ReturnJsonData<br>
* 类描述：   <br>
* 创建人：yangyi<br>
* 创建时间：2014-7-11 下午01:32:54<br>
* 修改人：yangyi<br>
* 修改时间：2014-7-11 下午01:32:54<br>
* 修改备注：   <br>
* @version 1.0<br>
* Copyright (c) 2014 Chongqing Rainbow Technology Co., Ltd. All Rights Reserved.  <br>
 */
@SuppressWarnings("unchecked")
public class ReturnJsonData {
	
	
	/**
	 * <p>说明： 把普通集合转换成 EasyUiTree要求的json数据格式</p>
	 * @param list 待转换的集合
	 * @param id 集合中表示ID的对象属性名的字符串，如："organizationCode"，必须
	 * @param text 集合中表示text的对象属性名的字符串，必须
	 * @param parentId 集合中表示父级ID的对象属性名的字符串
	 * @param state 集合中表示节点状态的对象属性名的字符串
	 * @param checked 集合中表示显示选定的节点是否选中的对象属性名的字符串
	 * @param isAttributes 集合中表示自定义属性的对象属性名的字符串
	 * @param params[0] 图标列表
	 * @return String 出错时返回null
	 * @author tuxy
	 * @date 2013-5-29
	 * <p>修改说明：</p>
	 * <p>修改者： 修改时间： </p>
	 */
	public static String list2easyUiTreeData(List<?> list,String id,String text,String parentId,String state,String checked,boolean isAttributes,Object... params) {
		String td = "";
		List<String> iconlist=null;
		if(params!=null&&params.length>0){
			iconlist=(List<String>) params[0];
		}
		try {
			if(list!=null && id != null && text != null){
				List<Map<String,Object>> treeList = new ArrayList<Map<String,Object>>();
				Map<String,Object> tree = null;
				Iterator<?> it = list.iterator();
				while(it.hasNext()){  //迭代
					tree = new HashMap<String,Object>();
					Object itObj = it.next(); //获取对象
					
					Class<? extends Object> type = itObj.getClass();
					BeanInfo beanInfo = Introspector.getBeanInfo(type);
					PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
					Map<String, Object> attrs=new HashMap<String, Object>();
					for (int i = 0; i < propertyDescriptors.length; i++) {
						PropertyDescriptor descriptor = propertyDescriptors[i];
						String propertyName = descriptor.getName();
						Object value=null;
						if (!propertyName.equals("class")) {
							Method readMethod = descriptor.getReadMethod();
							value = readMethod.invoke(itObj, new Object[0]);
						}
						attrs.put(propertyName, value);
						if(propertyName.equals(id)){
							tree.put("id", value);
							continue;
						}
						if(propertyName.equals(text)){  //属性为text的则存入tree的text属性里
							tree.put("text", value);
							continue;
						}
						if(propertyName.equals(state)){  //state
							tree.put("state", value);
							continue;
						}
						if(propertyName.equals(checked)){  //checked
							tree.put("checked", value);
							continue;
						}
						if(propertyName.equals(parentId)){  //parentId
							tree.put("parentId", value);
							continue;
						}
						if(propertyName.equals("attributes")){
							if(isAttributes){
								tree.put("attributes", value);
								continue;
							}
						}
					}
					if(tree.get("state")==null){
						tree.put("state", "closed");
					}
					treeList.add(tree);
				}
				if(parentId != null){
					List<Map<String,Object>> treeList2 = parentFlag2childrenArray(treeList);  //组装children
					if(iconlist!=null){
						setGrade(treeList2, 1,iconlist);
					}
					td = JSONArray.fromObject(treeList2).toString();  //转成json
				}else{
					td = JSONArray.fromObject(treeList).toString();  //转成json
				}
			}
		} catch (Exception e) {
			return null;
		}
		return td;
	}
	
    public static void setGrade(List<Map<String,Object>> treeList,int i,List<String> iconlist){
    	for(Map<String,Object> map:treeList){
    		map.put("grade", i);
    		if(iconlist.size()<i-1){
    			map.put("iconCls","tree-file");
    		}
    		else{
    			map.put("iconCls", iconlist.get(i-1));
    		}
    		if(map.get("children")!=null){
    			List<Map<String,Object>> children=(List<Map<String, Object>>) map.get("children");
    			setGrade(children, i+1,iconlist);
    		}
    	}
    }
	
	/**
	 * <p>说明： 按parentId组装成children数组 </p>
	 * @param treeList 格式为List<Map<String,Object>>，需包含id,parentId元素
	 * @return List<Map<String,Object>>
	 * @author tuxy
	 * @date 2013-5-29
	 * <p>修改说明：</p>
	 * <p>修改者： 修改时间： </p>
	 */
	private static List<Map<String,Object>> parentFlag2childrenArray(List<Map<String,Object>> treeList){
		//按pareantId把各个对象放入对应的父级对象的children数字里
		for(Map<String,Object> td:treeList){
			List<Map<String,Object>> children = new ArrayList<Map<String,Object>>();
			for(Map<String,Object> tdc:treeList){
				if(td.get("id").equals(tdc.get("parentId"))){
					children.add(tdc);
					tdc.put("isChild", "1");  //标记为子节点
				}
			}
			td.put("children",children);
		}
		//去掉被加为子节点的
		List<Map<String,Object>> childListReturn = new ArrayList<Map<String,Object>>();
		for(Map<String,Object> td:treeList){
			if(td.get("isChild")==null || !td.get("isChild").equals("1")){
				childListReturn.add(td);  //非子节点的才是要返回的
			}
		}
		return childListReturn;
	}
	
	
	


}
