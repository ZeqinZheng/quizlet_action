const puppeteer = require('puppeteer-extra');
const env = require('process').env;
const assert = require('assert');
puppeteer.use(require('puppeteer-extra-plugin-stealth')());

const ent_login = '#TopNavigationReactTarget > header > div > div.TopNavigation-contentRight > div.SiteNavLoginSection-loginButton > button > span';
const username = '#username';
const password = '#password';
const btn_login = 'body > div:nth-child(18) > div > div > div.c1yw38c3.c1cv2anc > section > div.avsxyiq > div > form > button > span > div > span';
const host = 'https://quizlet.com';
const redir_url = 'https://quizlet.com/latest';
const edit_studyset = 'https://quizlet.com/683855692/edit#addRow';
const entry_import = '#SetPageTarget > div > div.CreateSetHeader > div:nth-child(3) > div > button';
const text_area = '#SetPageTarget > div > div.ImportTerms.is-showing > div.ImportTerms-import > div > form > textarea';
const btn_import = '#SetPageTarget > div > div.ImportTerms.is-showing > div.ImportTerms-import > div > form > div.ImportTerms-importButtonWrap > button';
const request_url = 'https://quizlet.com/webapi/3.2/terms/save?_method=PUT';

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // login
  await page.goto(host);
  await page.click(ent_login);
  await page.screenshot({ path: 'login_page.png' });
  await page.type(username, env.USERNAME);
  await page.type(password, env.PASSWORD);
  await page.click(btn_login);
  await page.waitForNavigation({waitUntil: 'networkidle2'});
  await page.screenshot({ path: 'after_login.png' });
  assert(page.url(), redir_url);

  // enter edit page
  await page.goto(edit_studyset, {waitUntil: "load"});
  await page.screenshot({ path: 'edit_page.png' });
  await page.click(entry_import);
  await page.waitForSelector(btn_import);

  // post data
  await page.type(text_area, 'hello\tworld');
  await page.waitForSelector(btn_import+":enabled");
  await page.click(btn_import);
  const response = await page.waitForResponse(request_url);
  assert.equal(response.status(), 200);
  await page.screenshot({ path: 'quizlet.png' });
  await browser.close();
})();
