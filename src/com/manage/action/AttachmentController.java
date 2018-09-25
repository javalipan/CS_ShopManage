package com.manage.action;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.manage.util.FileUtils;
import com.manage.util.ImgUtil;

@Controller
@RequestMapping("/attachment")
public class AttachmentController {
	
	/**
	 * 功能描述:上传文件
	 * 
	 * @param request
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "/uploadFile.action")
	@ResponseBody
	public String uploadFileAndStore(HttpServletRequest request, ModelMap modelMap) {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();
		
		Date d = new Date();  
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");  
        String yearmonth = sdf.format(d);  

        File serverpath=new File(request.getSession().getServletContext().getRealPath("/"));
		String fileUrl =  serverpath.getParent()+"/upload/" + yearmonth + "/";
		Map<String,Object> map = new HashMap<String, Object>();
		try {
			Map.Entry<String, MultipartFile> entity = fileMap.entrySet().iterator().next(); 
				
			// 获取MulipartFile对象
			MultipartFile file = entity.getValue();
			InputStream inputStream = file.getInputStream();
			String fn = file.getOriginalFilename();
			
			//文件存储名
			sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String filename = sdf.format(d) +(Math.random() + "").substring(2, 6);  
			filename += fn.substring(fn.lastIndexOf("."));
			
				//上传失败，返回名称；上传成功，返回路径
			ImgUtil img=new ImgUtil(inputStream);
			File dir=new File(fileUrl);
			if(!dir.exists()){
				FileUtils.createDirs(dir);
			}
			FileOutputStream out=new FileOutputStream(fileUrl+filename);
			img.resizeAuto(out);
//			if (!FileUtils.fileUpload(inputStream, fileUrl, filename)) {
				map.put("isOk", false);
//			}else{
//				map.put("isOk", true);
//			}
			map.put("filePath", "/upload/" + yearmonth + "/"+filename);
			map.put("fileName", filename);	//服务器上的文件名
			map.put("fileSize", file.getSize());
			map.put("attachmentName", URLEncoder.encode(fn,"UTF-8")); //前台显示的附件名
			
		} catch (IOException e) {
			e.printStackTrace();
			map.put("isOk", false);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("isOk", false);
		}
		return JSONObject.fromObject(map).toString();
	}
	
}
