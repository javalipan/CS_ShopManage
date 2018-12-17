package com.manage.action.platform;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manage.action.BaseController;
import com.manage.constant.CommonConstant;
import com.manage.dao.model.Brand;
import com.manage.dao.model.BrandExample;
import com.manage.dao.model.Code;
import com.manage.dao.model.Goods;
import com.manage.dao.model.GoodsDetail;
import com.manage.dao.model.GoodsDetailExample;
import com.manage.dao.model.GoodsExample;
import com.manage.dao.model.Imgs;
import com.manage.dao.model.ImgsExample;
import com.manage.dao.model.OrderDetailExample;
import com.manage.dao.model.RepertoryExample;
import com.manage.dao.model.Spec;
import com.manage.dao.model.SpecExample;
import com.manage.query.model.GoodsDetailQuery;
import com.manage.query.model.GoodsQuery;
import com.manage.service.IBrandService;
import com.manage.service.ICodeService;
import com.manage.service.IGoodsDetailService;
import com.manage.service.IGoodsService;
import com.manage.service.IImgsService;
import com.manage.service.IOrderDetailService;
import com.manage.service.IRepertoryService;
import com.manage.service.ISpecService;
import com.manage.util.ArrayUtil;
import com.manage.util.Pager;
import com.manage.util.excel.ExcelUtil;

/**
 * 商品管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/goods")
public class GoodsController extends BaseController{

	@Autowired
	private IGoodsService goodsService;
	@Autowired
	private IGoodsDetailService goodsDetailService;
	@Autowired
	private IImgsService imgsService;
	@Autowired
	private IBrandService brandService;
	@Autowired
	private ISpecService specService;
	@Autowired
	private IOrderDetailService orderDetailService;
	@Autowired
	private IRepertoryService repertoryService;
	@Autowired
	private ICodeService codeService;
	
	@RequestMapping(value="/initGoodsList.action")
	public String initGoodsList(ModelMap model,String showcost){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		model.put("showcost", showcost);
		
		return "goods/goodslist";
	}
	
	@RequestMapping(value="/initGoodsList_emp.action")
	public String initGoodsList_emp(ModelMap model){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		model.put("showcost", "false");
		
		return "goods/goodslist";
	}
	
	@RequestMapping(value="/searchGoodss.action")
	@ResponseBody
	public String searchGoodss(ModelMap model,GoodsQuery goodsQuery,Pager pager){
		goodsQuery.setOrderBy("updatetime desc");
		goodsQuery.setPager(pager);
		int count=goodsService.countByGoodsQuery(goodsQuery);
		List<GoodsQuery> goodsList=goodsService.selectByGoodsQuery(goodsQuery);
		return DataGridJson(goodsList, count);
	}
	
	@RequestMapping(value="/initGoodsEdit.action")
	public String initGoodsEdit(ModelMap model,GoodsQuery goods,String showcost){
		List<Code> units=codeService.getCodesByType(CommonConstant.UNIT);
		List<Code> materials=codeService.getCodesByType(CommonConstant.MATERIAL);
		List<Code> standards=codeService.getCodesByType(CommonConstant.STANDARD);
		model.put("units", units);
		model.put("materials", materials);
		model.put("standards", standards);
		model.put("showcost", showcost);
		
		BrandExample brandExample=new BrandExample();
		brandExample.setOrderByClause("name asc");
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		
		SpecExample specExample=new SpecExample();
		specExample.createCriteria().andTypecodeEqualTo("color");
		specExample.setOrderByClause("sortno desc");
		List<Spec> colors=specService.selectByExample(specExample);
		model.put("colors", colors);
		
		SpecExample sizespecExample=new SpecExample();
		sizespecExample.createCriteria().andTypecodeEqualTo("size");
		sizespecExample.setOrderByClause("sortno desc");
		List<Spec> sizes=specService.selectByExample(sizespecExample);
		model.put("sizes", sizes);
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy");
		int year=Integer.parseInt(sdf.format(new Date()));
		model.put("year", year);
		
		if(goods!=null&&goods.getId()!=null){
			goods=goodsService.selectGoodsQueryById(goods.getId());
			model.put("goods", goods);
			
			ImgsExample imgsExample=new ImgsExample();
			imgsExample.createCriteria().andReceiptidEqualTo(goods.getId()).andTypeEqualTo("1");
			List<Imgs> imgs=imgsService.selectByExample(imgsExample);
			model.put("imgs", imgs);
			
			GoodsDetailQuery goodsDetailQuery=new GoodsDetailQuery();
			goodsDetailQuery.setGoodsid(goods.getId());
			List<GoodsDetailQuery> details=goodsDetailService.selectByGoodsDetailQuery(goodsDetailQuery);
			model.put("details", details);
			
			return "goods/goodsEdit";
		}
		else{
			return "goods/goodsAdd";
		}
	}
	
	@RequestMapping(value="/initGoodsDetail.action")
	public String initGoodsDetail(ModelMap model,GoodsQuery goods,String showcost){
		BrandExample brandExample=new BrandExample();
		List<Brand> brands=brandService.selectByExample(brandExample);
		model.put("brands", brands);
		
		SpecExample specExample=new SpecExample();
		specExample.createCriteria().andTypecodeEqualTo("color");
		List<Spec> colors=specService.selectByExample(specExample);
		model.put("colors", colors);
		
		SpecExample sizespecExample=new SpecExample();
		sizespecExample.createCriteria().andTypecodeEqualTo("size");
		List<Spec> sizes=specService.selectByExample(sizespecExample);
		model.put("sizes", sizes);
		
		goods=goodsService.selectGoodsQueryById(goods.getId());
		model.put("goods", goods);
		
		ImgsExample imgsExample=new ImgsExample();
		imgsExample.createCriteria().andReceiptidEqualTo(goods.getId()).andTypeEqualTo("1");
		List<Imgs> imgs=imgsService.selectByExample(imgsExample);
		model.put("imgs", imgs);
		
		GoodsDetailQuery goodsDetailQuery=new GoodsDetailQuery();
		goodsDetailQuery.setGoodsid(goods.getId());
		List<GoodsDetailQuery> details=goodsDetailService.selectByGoodsDetailQuery(goodsDetailQuery);
		model.put("details", details);
			
		model.put("showcost", showcost);
		
		return "goods/goodsDetail";
	}
	
	@RequestMapping(value="/saveGoods.action")
	@ResponseBody
	public String saveGoods(ModelMap model,Goods goods,String imgJson,String detailJson){
		goodsService.saveGoods(goods, detailJson, imgJson);
		return "保存成功!";
	}
	
	@RequestMapping(value="/updateGoodsStatus.action")
	@ResponseBody
	public String updateGoodsStatus(ModelMap model,String ids,String status){
		if(StringUtils.isBlank(ids)){
			return "操作失败";
		}
		goodsService.updateGoodsStatus(ids, status);
		return "操作成功";
	}
	
	@RequestMapping(value="/codeExists.do")
	@ResponseBody
	public String codeExists(String code){
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andCodeEqualTo(code);
		int count=goodsService.countByExample(goodsExample);
		if(count>0){
			return "true";
		}
		return "false";
	}
	
	@RequestMapping(value="updateDetailStatus.action")
	@ResponseBody
	public String updateDetailStatus(Long id,String status){
		goodsService.updateDetailStatus(id, status);
		return "操作成功";
	}
	
	@RequestMapping(value="/deleteGoods.action")
	@ResponseBody
	public String deleteGoods(ModelMap model,String ids){
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		GoodsDetailExample goodsDetailExample=new GoodsDetailExample();
		goodsDetailExample.createCriteria().andGoodsidIn(idlist);
		List<GoodsDetail> goodsDetails=goodsDetailService.selectByExample(goodsDetailExample);
		List<Long> detailids=new ArrayList<Long>();
		for(GoodsDetail gd:goodsDetails){
			detailids.add(gd.getId());
		}
		
		OrderDetailExample orderDetailExample=new OrderDetailExample();
		orderDetailExample.createCriteria().andGoodsdetailidIn(detailids);
		if(orderDetailService.countByExample(orderDetailExample)>0){
			return "商品已存在订单只能下架不能删除!";
		}
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andIdIn(idlist);
		goodsService.deleteByExample(goodsExample);
		
		RepertoryExample repertoryExample=new RepertoryExample();
		repertoryExample.createCriteria().andGoodsdetailidIn(detailids);
		repertoryService.deleteByExample(repertoryExample);
		return "删除成功";
	}
	
	@RequestMapping(value="/exportExcel.action")
	@ResponseBody
	public void exportExcel(HttpServletResponse response,ModelMap model,GoodsQuery goodsQuery) throws IOException{
		goodsQuery.setOrderBy("updatetime desc");
		List<GoodsQuery> goodsQueries=goodsService.selectByGoodsQuery(goodsQuery);
		JSONArray data=new JSONArray();
		for(GoodsQuery g:goodsQueries){
			GoodsDetailQuery goodsDetailQuery=new GoodsDetailQuery();
			goodsDetailQuery.setGoodsid(g.getId());
			List<GoodsDetailQuery> detailQuerys=goodsDetailService.selectByGoodsDetailQuery(goodsDetailQuery);
			for(GoodsDetailQuery gd:detailQuerys){
				JSONObject obj=new JSONObject();
				obj.put("name", g.getName());
				obj.put("color", gd.getColorName());
				obj.put("size", gd.getSizeName());
				obj.put("price", gd.getPrice());
				obj.put("code", g.getCode());
				obj.put("detailcode", gd.getDetailcode());
				obj.put("standard", g.getStandard()==null?"":g.getStandard());
				obj.put("unit", g.getUnit()==null?"":g.getUnit());
				obj.put("material", g.getMaterial()==null?"":g.getMaterial());
				obj.put("num", gd.getAmount());
				data.add(obj);
			}
		}
		ExcelUtil.exportLabelExcel(response, data);
	}
	
	@RequestMapping(value="/modifysort.action")
	@ResponseBody
	public String modifysort(HttpServletResponse response,ModelMap model,Goods goods) {
		if(goods.getId()==null||goods.getSortno()==null){
			return "操作失败!";
		}
		Goods temp=new Goods();
		temp.setId(goods.getId());
		temp.setSortno(goods.getSortno());
		goodsService.updateByPrimaryKeySelective(goods);
		return "修改成功";
	}
	
	/** 
	*  更新是否推荐
	* @param ids ：id列表
	* @param isrecomment： 是否推荐,0:否，1：是
	* @return String     
	*/
	@RequestMapping(value="/updateRecomment.action")
	@ResponseBody
	public String updateRecomment(String ids,String isrecomment) {
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		Goods goods=new Goods();
		goods.setIsrecomment(isrecomment);
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andIdIn(idlist);
		goodsService.updateByExampleSelective(goods, goodsExample);
		return "修改成功";
	}
	
	/** 
	 *  更新是否推荐
	 * @param ids ：id列表
	 * @param isnew： 是否新品,0:否，1:是
	 * @return String     
	 */
	@RequestMapping(value="/updateNew.action")
	@ResponseBody
	public String updateNew(String ids,String isnew) {
		if(StringUtils.isBlank(ids)){
			return "删除失败";
		}
		List<Long> idlist=ArrayUtil.idsToLongList(ids);
		Goods goods=new Goods();
		goods.setIsnew(isnew);
		GoodsExample goodsExample=new GoodsExample();
		goodsExample.createCriteria().andIdIn(idlist);
		goodsService.updateByExampleSelective(goods, goodsExample);
		return "修改成功";
	}
}
